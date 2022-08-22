# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit prefix

DESCRIPTION="LSB version query program"
HOMEPAGE="https://wiki.linuxfoundation.org/lsb/"
# mirror://sourceforge/lsb/${P}.tar.gz
SRC_URI="https://github.com/thkukuk/lsb-release_os-release/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}_os-release-${PV}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

# Perl isn't needed at runtime, it is just used to generate the man page.
BDEPEND="dev-lang/perl"

src_prepare() {
	default

	# Use POSIX 'printf' instead of bash 'echo -e', bug #482370
	sed -i \
		-e "s:echo -e:printf '%b\\\n':g" \
		-e 's:--long:-l:g' \
		lsb_release || die

	# TODO: unbundle help2man?
	hprefixify lsb_release help2man
}

src_install() {
	emake prefix="${ED}"/usr install

	dodir /etc
	cat > "${ED}"/etc/lsb-release <<- EOF || die
		DISTRIB_ID="Gentoo"
	EOF
}
