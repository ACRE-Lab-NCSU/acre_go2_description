import os
from launch import LaunchDescription
from launch_ros.actions import Node
from launch.substitutions import Command, LaunchConfiguration
from launch.actions import DeclareLaunchArgument
from ament_index_python.packages import get_package_share_directory


def generate_launch_description():
    pkg_share = get_package_share_directory('acre_go2_description')
    default_urdf_path = os.path.join(pkg_share, 'urdf', 'go2.urdf.xacro')
    default_rviz_config = os.path.join(pkg_share, 'rviz', 'display.rviz')

    urdf_arg = DeclareLaunchArgument(
        'urdf_path',
        default_value=default_urdf_path,
        description='Path to the robot xacro/urdf file'
    )

    use_gui_arg = DeclareLaunchArgument(
        'use_joint_state_gui',
        default_value='true',
        description='Launch joint_state_publisher_gui for manual joint sliders'
    )

    robot_description = Command(['xacro ', LaunchConfiguration('urdf_path')])

    robot_state_publisher = Node(
        package='robot_state_publisher',
        executable='robot_state_publisher',
        name='robot_state_publisher',
        output='screen',
        parameters=[{'robot_description': robot_description}]
    )

    joint_state_publisher_gui = Node(
        package='joint_state_publisher_gui',
        executable='joint_state_publisher_gui',
        name='joint_state_publisher_gui',
        output='screen',
        condition=None
    )

    rviz = Node(
        package='rviz2',
        executable='rviz2',
        name='rviz2',
        output='screen',
        arguments=['-d', default_rviz_config] if os.path.exists(default_rviz_config) else []
    )

    return LaunchDescription([
        urdf_arg,
        use_gui_arg,
        robot_state_publisher,
        joint_state_publisher_gui,
        rviz,
    ])