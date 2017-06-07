create or replace PACKAGE BODY <%= queue_name %>_queue IS

  PROCEDURE
    enqueue_message(payload VARCHAR2)
  IS
    msg                <%= payload_name %> := <%= payload_name %>(NULL);
    msg_id             RAW(16);
    enqueue_options    DBMS_AQ.ENQUEUE_OPTIONS_T;
    message_properties DBMS_AQ.MESSAGE_PROPERTIES_T;
  BEGIN
    msg.json                    := payload;
    message_properties.priority := 1;  -- give all messages same priority
    DBMS_AQ.ENQUEUE(
      queue_name         => '<%= queue_name %>',
      enqueue_options    => enqueue_options,
      message_properties => message_properties,
      payload            => msg,
      msgid              => msg_id
    );
  END enqueue_message;

  PROCEDURE
    dequeue_message(payload OUT VARCHAR2)
  IS
    msg                <%= payload_name %> := <%= payload_name %>(NULL);
    msg_id             RAW(16);
    dequeue_options    DBMS_AQ.DEQUEUE_OPTIONS_T;
    message_properties DBMS_AQ.MESSAGE_PROPERTIES_T;
  BEGIN
    DBMS_AQ.DEQUEUE(
      queue_name         => '<%= queue_name %>',
      dequeue_options    => dequeue_options,
      message_properties => message_properties,
      payload            => msg,
      msgid              => msg_id
    );
    payload := msg.json;
  END dequeue_message;

END <%= queue_name %>_queue;
