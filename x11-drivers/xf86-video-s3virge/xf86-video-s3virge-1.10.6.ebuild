# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-s3virge/xf86-video-s3virge-1.10.6.ebuild,v 1.6 2012/12/30 14:50:16 ago Exp $

EAPI=4
inherit xorg-2

DESCRIPTION="S3 ViRGE video driver"

KEYWORDS="alpha amd64 ia64 ppc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.0.99"
DEPEND="${RDEPEND}"
