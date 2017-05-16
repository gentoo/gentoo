# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @DEAD
# Michał Górny <mgorny@gentoo.org> (16 May 2017)
# gst-plugins* eclasses are no longer used. They will be removed
# in 30 days.

# @ECLASS: gst-plugins-ugly.eclass
# @MAINTAINER:
# gstreamer@gentoo.org
# @AUTHOR:
# Gilles Dartiguelongue <eva@gentoo.org>
# Saleem Abdulrasool <compnerd@gentoo.org>
# foser <foser@gentoo.org>
# zaheerm <zaheerm@gentoo.org>
# @BLURB: Manages build for invididual ebuild for gst-plugins-ugly.
# @DESCRIPTION:
# See gst-plugins10.eclass documentation.

GST_ORG_MODULE="gst-plugins-ugly"

inherit gst-plugins10

case "${EAPI:-0}" in
	1|2|3|4|5)
		;;
	0)
		die "EAPI=\"${EAPI}\" is not supported anymore"
		;;
	*)
		die "EAPI=\"${EAPI}\" is not supported yet"
		;;
esac

