# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/roadrunner/roadrunner-0.9.1.ebuild,v 1.10 2014/07/22 20:31:47 mrueg Exp $

# EBuild details
DESCRIPTION="RoadRunner library provides API for using Blocks Extensible Exchange Protocol"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage" #was http://rr.codefactory.se
# upstream Died
SRC_URI="mirror://gentoo/roadrunner-${PV}.tar.gz"

LICENSE="Sleepycat"
SLOT="0"
KEYWORDS="x86 ppc"

# doc		= include documentation
IUSE="doc"

RDEPEND=">=dev-libs/glib-2.2.1
	>=dev-libs/libxml2-2.5.11"

DEPEND="
	>=dev-libs/glib-2.2.1
	>=dev-libs/libxml2-2.5.11
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )"

src_compile() {
	econf \
		$(use_enable doc gtk-doc) \
		|| die "configure failed"

	emake || die "emake failed"
}

src_install() {
	# Seems that the Makefiles are OK
	emake DESTDIR="${D}" install || die
}
