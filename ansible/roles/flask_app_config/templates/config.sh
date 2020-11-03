
### general configurations


# when value is local_development, app takes into account some small differences in dev env
NKR_ENV="{{ deployment_environment_id }}"

# extra debugging info and diagnostics output
DEBUG="{{ flask_app.debug | default('0') }}"

# extra debugging info and diagnostics output. this is passed to python logging module.
LOG_LEVEL="{{ flask_app.log_level | default('INFO') }}"

# if envs use self-signed certificates, set to false.
VERIFY_TLS="{{ flask_app.verify_tls | default('1') }}"


### rems configurations


REMS_HOST="{{ flask_app.rems_host }}"
REMS_API_KEY="{{ flask_app.rems_api_key }}"
REMS_REJECTER_BOT_USER="{{ flask_app.rems_rejecter_bot_user }}"


### index configurations


# comma-separated list of hosts. for localhost development, include port (host:prt)
INDEX_HOSTS="{{ flask_app.index_hosts|join(',') }}"
INDEX_MAIN_API="{{ flask_app.index_main_api }}"
INDEX_NAME="{{ flask_app.index_name }}"

# credentials for accessing the index
INDEX_USERNAME="{{ flask_app.index_username }}"
INDEX_PASSWORD="{{ flask_app.index_password }}"

# comma-separated list of apis of the index that can be used through the proxy
INDEX_ALLOWED_APIS="{{ flask_app.index_allowed_apis }}"

# name of the field in an index document that defines the document's access restriction level
LEVEL_RESTRICTION_FIELD="{{ flask_app.level_restriction_field }}"

# name of the unique id field in an index document. "id" field is not actually unique,
# since multiple documents of different restriction levels can have the same id.
# from the point of view of a requesting service, the "id" field IS unique, since only
# one level of a document can be returned at a time.
DOCUMENT_UNIQUE_ID_FIELD="{{ flask_app.document_unique_id_field }}"

# identifier of the resource in rems that grants access to level 10 metadata
METADATA_LEVEL_10_RESOURCE_ID="{{ flask_app.metadata_level_10_resource_id }}"


### cache configurations


CACHE_HOST="{{ cache.host }}"
CACHE_PORT="{{ cache.port }}"
CACHE_PASSWORD="{{ cache.password }}"
CACHE_DB="{{ cache.db }}"
CACHE_SOCKET_TIMEOUT="{{ cache.socket_timeout }}"


### session expiry check configurations


# user inactive for this period of time will have their rems application closed
SESSION_TIMEOUT_LIMIT="{{ session_check_session_timeout_limit }}"

# user active for this period of time will have their rems application closed
SESSION_TIMEOUT_LIMIT_LONG="{{ session_check_session_timeout_limit_long }}"

# for now only a warning message is logged that clearing sessions is taking a longer-than-expected
# amount of time.
SESSION_CLEANUP_MAX_TIME="{{ session_check_session_cleanup_max_time }}"

# when user application is closed, this message is entered as reason
REMS_SESSION_CLOSE_MESSAGE="{{ session_check_rems_session_close_message }}"

# when user application is closed after daily maximum length of session is reached, this message is entered as reason
REMS_SESSION_CLOSE_MESSAGE_ACTIVE="{{ session_check_rems_session_close_message_active }}"

# when user application is closed, this user id is used to close it. this message is also
# used to help define the value for x-user-access-status response header.
REMS_SESSION_CLOSE_USER="{{ session_check_rems_session_close_user }}"

# this message is used to help define the value for x-user-access-status response header.
REMS_LOGOUT_MESSAGE="{{ session_check_rems_logout_message }}"

# log file fron "session expiry check" cron job
CRON_SESSION_EXPIRE_LOG="{{ session_check_cron_session_expire_log }}"


### Request restriction configurations

# Sliding windows for request limits
SHORT_TIMEFRAME="{{ flask_app.short_timeframe }}" 
LONG_TIMEFRAME="{{ flask_app.long_timeframe }}"

# Maximum amount of requests 
MAX_AMOUNT_OF_REQUESTS_SHORT_PERIOD="{{ flask_app.max_amount_of_requests_short_period }}"
MAX_AMOUNT_OF_REQUESTS_LONG_PERIOD="{{ flask_app.max_amount_of_requests_long_period }}"

# these values are meant for including the right requests in counting the number of requests
EXCLUDE_REQUESTS_WITH_FIELD_PARAM="{{ flask_app.exclude_requests_with_field_param }}"
INCLUDE_REQUESTS_WITH_FIELD_PARAM="{{ flask_app.include_requests_with_field_param }}"
INCLUDE_REQUESTS_WITH_QUERY_PARAM="{{ flask_app.include_requests_with_query_param }}"
EXCLUDE_REQUESTS_WITH_QUERY_PARAM="{{ flask_app.exclude_requests_with_query_param }}"

REQUEST_TIME_DIFFERENCE="{{ flask_app.request_time_difference }}"

# after a notification about exceeded request limit is sent, the next notification can be sent after the time specified here has passed
LIMIT_FOR_SENDING_NEW_EMAIL="{{ flask_app.limit_for_sending_new_email }}"

MAIL_MAX_EMAILS="{{ flask_app.mail_max_emails }}"

MAIL_SHORT_PERIOD="{{ flask_app.mail.short_period }}"
MAIL_LONG_PERIOD="{{ flask_app.mail.long_period }}"
MAIL_SERVER="{{ flask_app.mail.server }}"
MAIL_PORT="{{ flask_app.mail.port }}"
MAIL_USE_TLS="{{ flask_app.mail.use_tls }}"
MAIL_USE_SSL="{{ flask_app.mail.use_ssl }}"
MAIL_DEFAULT_SENDER="{{ flask_app.mail.default_sender }}"
MAIL_RECIPIENT="{{ flask_app.mail.recipient }}"
    