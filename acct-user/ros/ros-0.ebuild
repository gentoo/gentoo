# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for dev-ros/roslaunch"

ACCT_USER_GROUPS=( "ros" )
ACCT_USER_HOME="/home/ros"
ACCT_USER_ID="130"

acct-user_add_deps
