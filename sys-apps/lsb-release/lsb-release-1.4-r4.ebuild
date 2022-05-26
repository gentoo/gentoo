# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit prefix

DESCRIPTION="LSB version query program"
HOMEPAGE="https://wiki.linuxfoundation.org/lsb/"
SRC_URI="mirror://sourceforge/lsb/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

# Perl isn't needed at runtime, it is just used to generate the man page.
BDEPEND="dev-lang/perl"

PATCHES=(
	"${FILESDIR}"/${P}-os-release.patch # bug 443116
)

src_prepare() {
	default

	# use POSIX 'printf' instead of bash 'echo -e', bug #482370
	sed -i \
		-e "s:echo -e:printf '%b\\\n':g" \
		-e 's:--long:-l:g' \
		lsb_release || die

	hprefixify lsb_release
}

src_install() {
	emake \
		prefix="${ED}/usr" \
		mandir="${ED}/usr/share/man" \
		install

	# installs gz compressed manpage, https://bugs.gentoo.org/729140
	rm "${ED}/usr/share/man/man1/lsb_release.1.gz" || die
	gunzip lsb_release.1.gz
	doman lsb_release.1

	dodir /etc
	cat > "${ED}/etc/lsb-release" <<- EOF || die
		DISTRIB_ID="Gentoo"
	EOF
}
