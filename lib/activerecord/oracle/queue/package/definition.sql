create or replace PACKAGE <%= queue_name %>_queue IS

  -- Created : <%= Time.now.strftime("%d.%m.%Y %H:%M:%S") %>
  -- Purpose : For en- and dequeue message in the <%= queue_name %> queue

  PROCEDURE enqueue_message(payload VARCHAR2);

  PROCEDURE dequeue_message(payload OUT VARCHAR2);

END <%= queue_name %>_queue;
