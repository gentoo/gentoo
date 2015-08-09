# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# Until ATI's SDK is in the tree, nvidia is the only
# viable provider #392179 #257626

EAPI="4"

DESCRIPTION="Virtual for OpenCL implementations"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
#CARDS=( fglrx nvidia )
CARDS=( nvidia )
IUSE="${CARDS[@]/#/video_cards_}"

REQUIRED_USE="|| ( ${IUSE} )"

#		video_cards_fglrx? ( x11-drivers/ati-drivers[opencl] )
RDEPEND="|| (
		video_cards_nvidia? ( x11-drivers/nvidia-drivers >=dev-util/nvidia-cuda-toolkit-3.1 )
	)"
