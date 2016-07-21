# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

CHOST="avr"
CTARGET="avr"

inherit flag-o-matic

DOCS_PV="1.6.2"

DESCRIPTION="C library for Atmel AVR microcontrollers"
HOMEPAGE="http://www.nongnu.org/avr-libc/"
SRC_URI="https://savannah.nongnu.org/download/avr-libc/${P}.tar.bz2
	https://savannah.nongnu.org/download/avr-libc/${PN}-manpages-${DOCS_PV}.tar.bz2
	doc? ( https://savannah.nongnu.org/download/avr-libc/${PN}-user-manual-${DOCS_PV}.tar.bz2 )"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="doc nls crosscompile_opts_headers-only"

DEPEND=">=sys-devel/crossdev-0.9.1"
[[ ${CATEGORY/cross-} != ${CATEGORY} ]] \
	&& RDEPEND="!dev-embedded/avr-libc" \
	|| RDEPEND=""

pkg_setup() {
	# check for avr-gcc, bug #134738
	ebegin "Checking for avr-gcc"
	if type -p avr-gcc > /dev/null ; then
		eend 0
	else
		eend 1

		eerror
		eerror "Failed to locate 'avr-gcc' in \$PATH. You can install an AVR toolchain using:"
		eerror "  $ crossdev -t avr"
		eerror
		die "AVR toolchain not found"
	fi
}

src_compile() {
	strip-flags
	strip-unsupported-flags

	mkdir obj-avr
	cd "${S}"/obj-avr

	ECONF_SOURCE="${S}" \
	econf \
		$(use_enable nls) \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	cd "${S}"/obj-avr
	emake DESTDIR="${D}" install || die "make install failed"

	cd "${S}"
	dodoc AUTHORS ChangeLog* NEWS README

	# man pages can not go into standard locations
	# as they would then overwrite libc man pages
	dosed "s:\$(VERSION):${PVR}:" /usr/bin/avr-man
	insinto /usr/share/doc/${PF}/man/man3
	doins "${WORKDIR}"/man/man3/*
	prepman /usr/share/doc/${PF}

	use doc	&& dohtml "${WORKDIR}"/${PN}-user-manual-${DOCS_PV}/*
}
