# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/symon/symon-2.87.ebuild,v 1.3 2014/11/26 00:07:04 dilfridge Exp $

EAPI=5
inherit eutils perl-module toolchain-funcs

DESCRIPTION="Performance and information monitoring tool"
HOMEPAGE="http://www.xs4all.nl/~wpd/symon/"
SRC_URI="http://www.xs4all.nl/~wpd/symon/philes/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="perl +symon symux"

RDEPEND="perl? ( dev-lang/perl )
	symux? ( net-analyzer/rrdtool )"
DEPEND="${RDEPEND}
	virtual/pmake"

S=${WORKDIR}/${PN}

# Deletes the directory passed as an argument from the internal pmake
# variable SUBDIR.
zap_subdir() {
	sed -i "/^SUBDIR/s|$1||" Makefile || die
}

pkg_setup() {
	use symon && USE_SYMON=1 && return

	if ! use perl && ! use symon && ! use symux; then
		ewarn "You have all available USE flags disabled. Therefore, only the"
		ewarn "system monitor will be emerged. Please, enable at least one USE"
		ewarn "flag to avoid this message."
		USE_SYMON=1
	fi
}

src_prepare() {
	sed -i \
		-e '/^[ \t]*${CC}.*\${LIBS}/s:\${CC}:$(CC) $(LDFLAGS):' \
		sym*/Makefile || die
}

src_configure() {
	# Do some sed magic in accordance with the USE flags.
	use perl && [[ -z ${USE_SYMON} ]] && ! use symux && zap_subdir lib
	! use perl && zap_subdir client
	! use symux && zap_subdir symux
	[[ -z ${USE_SYMON} ]] && zap_subdir symon
}

src_compile() {
	pmake CC="$(tc-getCC)" CFLAGS+="${CFLAGS}" STRIP=true || die "pmake failed"
}

src_install() {
	if [[ -n ${USE_SYMON} ]]; then
		insinto /etc
		doins "${FILESDIR}"/symon.conf

		newinitd "${FILESDIR}"/symon-init.d symon

		dodoc CHANGELOG HACKERS TODO

		doman symon/symon.8
		dosbin symon/symon
	fi

	if use perl; then
		dobin client/getsymonitem.pl

		perl_set_version
		insinto ${VENDOR_LIB}
		doins client/SymuxClient.pm
	fi

	if use symux; then
		insinto /etc
		doins "${FILESDIR}"/symux.conf

		newinitd "${FILESDIR}"/symux-init.d symux

		doman symux/symux.8
		dosbin symux/symux

		dodir /usr/share/symon
		insinto /usr/share/symon
		doins symux/c_smrrds.sh
		fperms a+x /usr/share/symon/c_smrrds.sh

		dodir /var/lib/symon/rrds/localhost
	fi
}

pkg_postinst() {
	if use symux; then
		elog "The RRDs files can be obtained by running"
		elog "/usr/share/symon/c_smrrds.sh all."
		elog "For information about migrating RRDs from a previous"
		elog "symux version read the LEGACY FORMATS section of symux(8)."
		elog "To view the rrdtool pictures of the stored data, emerge"
		elog "net-analyzer/syweb."
	fi
}
