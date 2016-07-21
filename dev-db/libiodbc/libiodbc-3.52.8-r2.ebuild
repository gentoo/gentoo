# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools eutils multilib-minimal

MY_PN="iODBC"

DESCRIPTION="ODBC Interface for Linux"
HOMEPAGE="http://www.iodbc.org/"
SRC_URI="https://github.com/openlink/${MY_PN}/archive/v${PV}.zip -> ${P}.zip"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
LICENSE="|| ( LGPL-2 BSD )"
SLOT="0"
IUSE="gtk"

RDEPEND="gtk? ( x11-libs/gtk+:2[${MULTILIB_USEDEP}] )"

DEPEND="${RDEPEND}"

DOCS="AUTHORS ChangeLog NEWS README"

S="${WORKDIR}/${MY_PN}-${PV}"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/iodbc-config
)

src_prepare() {
	sed -i.orig \
		-e '/^cd "$PREFIX"/,/^esac/d' \
		iodbc/install_libodbc.sh || die "sed failed"
	epatch \
		"${FILESDIR}"/libiodbc-3.52.7-debian_bug501100.patch \
		"${FILESDIR}"/libiodbc-3.52.7-debian_bug508480.patch \
		"${FILESDIR}"/libiodbc-3.52.7-gtk.patch \
		"${FILESDIR}"/libiodbc-3.52.7-multilib.patch \
		"${FILESDIR}"/libiodbc-3.52.7-unicode_includes.patch \
		"${FILESDIR}"/libiodbc-3.52.8-gtk-parallel-make.patch \
		"${FILESDIR}"/libiodbc-3.52.8-runtime-failures.patch \
		"${FILESDIR}"/fix-runpaths.patch
	chmod -x include/*.h || die
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf \
		--disable-static \
		--enable-odbc3 \
		--enable-pthreads \
		--with-layout=gentoo \
		--with-iodbc-inidir=yes \
		$(use_enable gtk gui)
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files

	# Install lintian overrides
	insinto /usr/share/lintian/overrides
	newins debian/iodbc.lintian-overrides iodbc
	newins debian/libiodbc2.lintian-overrides libiodbc2
}
