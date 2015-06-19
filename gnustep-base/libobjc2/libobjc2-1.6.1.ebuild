# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-base/libobjc2/libobjc2-1.6.1.ebuild,v 1.1 2012/07/25 12:11:23 voyageur Exp $

EAPI=4
inherit multilib

# We need gnustep-make, but gnustep-make can depend on libobjc
# Use a temporary setup to install in /usr/
GSMAKE=gnustep-make-2.6.2
DESCRIPTION="GNUstep Objective-C runtime"
HOMEPAGE="http://www.gnustep.org"
SRC_URI="http://download.gna.org/gnustep/${P}.tar.bz2
	ftp://ftp.gnustep.org/pub/gnustep/core/${GSMAKE}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+boehm-gc"

RDEPEND="boehm-gc? ( dev-libs/boehm-gc )"
DEPEND="${DEPEND}
	>=sys-devel/clang-2.9"

GSMAKE_S=${WORKDIR}/${GSMAKE}

src_prepare() {
	# Remove CFLAGS from assembly calls
	sed -e "s/\$(ALL_CFLAGS)//" -i GNUmakefile || die "Assembly sed failed"
	# Multilib-strict
	cd "${GSMAKE_S}"
	sed -e "s/lib/$(get_libdir)/g" \
		-i FilesystemLayouts/fhs-system || die "multilib path sed failed"
}

src_configure() {
	export CC=clang

	cd "${GSMAKE_S}"
	econf --with-layout=fhs-system
}

src_compile() {
	local gb
	use boehm-gc \
		&& gb="boehm_gc=yes" \
		|| gb="boehm_gc=no"
	emake GNUSTEP_MAKEFILES="${GSMAKE_S}" messages=yes ${gb}
}

src_install() {
	emake GNUSTEP_MAKEFILES="${GSMAKE_S}" \
		GNUSTEP_CONFIG_FILE="${GSMAKE_S}"/GNUstep.conf \
		GNUSTEP_INSTALLATION_DOMAIN=SYSTEM \
		messages=yes \
		DESTDIR="${D}" install
}
