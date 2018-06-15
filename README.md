# docker-abf
How to config user account:
'''
source envfile
cd rosa-build
rails c
a=User.find_by_email("email")
a.confirmed_at = Time.now
a.save
'''
