# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit gst-plugins-bad

KEYWORDS="alpha amd64 ppc ppc64 x86"
IUSE=""

RDEPEND=">=net-libs/neon-0.27"
DEPEND="${RDEPEND}"

src_prepare() {
	# Allow building with neon-0.30 and avoid eautoreconf
	# https://bugzilla.gnome.org/show_bug.cgi?id=705812
	sed -e 's#neon <= 0.29.99#neon <= 0.30.99#' -i configure{.ac,} || die
}
