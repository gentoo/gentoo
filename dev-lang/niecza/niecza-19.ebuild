# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils multilib

GITHUB_CRAP="sorear-niecza-3743eb0"

DESCRIPTION="A Perl 6 compiler targetting the CLR with an experimental focus on optimizations"
HOMEPAGE="https://github.com/sorear/niecza"
#SRC_URI="https://github.com/downloads/sorear/${PN}/${P}.zip"
SRC_URI="https://github.com/sorear/niecza/zipball/v19 -> niecza-19.zip"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/mono"
DEPEND="${RDEPEND}
	|| ( dev-lang/niecza-bin dev-lang/niecza )"

S=${WORKDIR}/${GITHUB_CRAP}

src_prepare() {
	epatch "${FILESDIR}"/fix-bootstrap.patch || die "Failed to fix"
	cd "${S}"
	# bootstrap only works from git dirs? sigh :)
	sed -i -e 's:@git describe --tags:echo "v19":' Makefile
	# silly workaround for stuff trying to write everywhere: copy the installed niecza here (sigh)
	# since we have different installation paths for the bin version we need to check here
	mkdir boot -p
	if has_version dev-lang/niecza; then
		cp -r /opt/niecza/* boot/
	else
		cp -r /opt/niecza-bin/* boot/
	fi
}

src_configure() { :; }

src_compile() {
	emake -j1 || die
}

src_test() {
	emake -j1 test || die
}

src_install() {
	mkdir -p "${D}"/opt/niecza
	for i in docs lib obj run README.pod; do
		cp -r "${S}"/$i "${D}"/opt/niecza/ || die "Failed to install"
	done
}
