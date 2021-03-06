"""
gunicorn WSGI server configuration.
"""

from multiprocessing import cpu_count


def max_workers():
    return cpu_count() * 2 + 1


max_requests = 100
worker_class = 'gevent'
workers = max_workers()
timeout = 60


secure_scheme_headers = {
    'X-FORWARDED-PROTOCOL': 'ssl',
    'X-FORWARDED-PROTO': 'https',
    'X-FORWARDED-SSL': 'on'
}
