# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Configurable talking ASCII cow (and other characters)"
HOMEPAGE="https://github.com/tnalpgge/rank-amateur-cowsay"
SRC_URI="https://github.com/tnalpgge/rank-amateur-${PN}/archive/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc64 ~x86 ~x64-solaris"

RDEPEND=">=dev-lang/perl-5"
BDEPEND="${RDEPEND}"
PATCHES=(
	"${FILESDIR}/${P}-tongue.patch"
	"${FILESDIR}/${P}-mech.patch"
	"${FILESDIR}/${P}-utf8.patch"
	"${FILESDIR}/${P}-version.patch" )

S="${WORKDIR}/rank-amateur-${PN}-${P}"

src_prepare() {
	sed	-i \
		-e "1 c\#!${EPREFIX}/usr/bin/perl"\
		-e 's/\$version/\$VERSION/g'\
		-e "s:%PREFIX%/share/cows:${EPREFIX}/usr/share/${P}/cows:" \
		-e '/getopts/ i\$Getopt::Std::STANDARD_HELP_VERSION=1;' cowsay \
			|| die "sed cowsay failed"
	sed -i \
		-e "s|%PREFIX%/share/cows|${EPREFIX}/usr/share/${P}/cows|" cowsay.1 \
			|| die "sed cowsay.1 failed"

	default
}

src_compile() {
	./install.sh "${D}"
}

src_install() {
	dobin cowsay
	doman cowsay.1
	dosym cowsay /usr/bin/cowthink
	dosym cowsay.1 /usr/share/man/man1/cowthink.1
	insinto /usr/share/${P}
	doins -r cows
	einstalldocs
}
