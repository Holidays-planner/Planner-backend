import logging

from models import Users, Roles, UserRoles
import os


class DatabaseUtils:
    @classmethod
    def start(cls):
        cls.insert_admin_user()

    @classmethod
    def insert_admin_user(cls):
        logger = logging.getLogger(__name__)
        admin_username = os.getenv("ADMIN_USER")
        admin_password = os.getenv("ADMIN_PASSWORD")
        admin_email = os.getenv("ADMIN_EMAIL")
        if not admin_username or not admin_password or not admin_email:
            logger.info("Admin user, password, or email not set in environment variables.")
            return
        user = Users.query.filter_by(email=admin_email).first()
        if user is None:
            user = Users(
                username=admin_username,
                email=admin_email,
                password=admin_password,
                status="active"
            )
            user.save()
            logger.info("Admin user created successfully.")
        admin_role = Roles.query.filter_by(role_name="admin").first()
        user_id = user.id
        user_role = UserRoles.query.filter_by(user_id=user_id).first()
        if user_role is None:
            user_role = UserRoles(
                user_id=user_id,
                role_id=admin_role.id
            )
            user_role.save()
            logger.info("Admin role assigned to admin user.")