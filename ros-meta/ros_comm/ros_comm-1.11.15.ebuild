# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="ROS communications-related packages"
LICENSE="BSD"
SLOT="0"
IUSE=""

# utilities subdir
RDEPEND="
	dev-ros/roslz4
	dev-ros/xmlrpcpp
	dev-ros/roswtf
	dev-ros/message_filters
"
# tools subdir
RDEPEND="${RDEPEND}
	dev-ros/rosbag
	dev-ros/rosbag_storage
	dev-ros/rosconsole
	dev-ros/rosgraph
	dev-ros/roslaunch
	dev-ros/rosmaster
	dev-ros/rosmsg
	dev-ros/rosnode
	dev-ros/rosout
	dev-ros/rosparam
	dev-ros/rosservice
	dev-ros/rostest
	dev-ros/rostopic
	dev-ros/topic_tools
"
# clients subdir
RDEPEND="${RDEPEND}
	dev-ros/roscpp
	dev-ros/rospy
"
# test subdir
RDEPEND="${RDEPEND}
	dev-ros/test_rosbag
	dev-ros/test_rosbag_storage
	dev-ros/test_roscpp
	dev-ros/test_rosgraph
	dev-ros/test_roslaunch
	dev-ros/test_roslib_comm
	dev-ros/test_rosmaster
	dev-ros/test_rosparam
	dev-ros/test_rospy
	dev-ros/test_rosservice
"
DEPEND="${RDEPEND}"
