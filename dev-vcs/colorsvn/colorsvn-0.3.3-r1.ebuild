# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Subversion output colorizer"
HOMEPAGE="http://colorsvn.tigris.org"
SRC_URI="http://colorsvn.tigris.org/files/documents/4414/49311/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~x64-macos"

RDEPEND="
	dev-lang/perl
	dev-vcs/subversion"
BDEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-use-open2-not-open3.patch
	"${FILESDIR}"/${P}-prefix-fhs.patch
)

src_compile() {
	# bug 335134
	emake -j1
}

pkg_postinst() {
	elog
	elog "The default settings are stored in /etc/colorsvnrc."
	elog "They can be locally overridden by ~/.colorsvnrc."
	elog "An alias to colorsvn was installed for the svn command."
	elog "In order to immediately activate it do:"
	elog "\tsource /etc/profile"
	elog "NOTE: If you don't see colors,"
	elog "append the output of 'echo \$TERM' to 'colortty' in your colorsvnrc."
	elog
}
