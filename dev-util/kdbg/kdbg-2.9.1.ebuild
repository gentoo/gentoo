# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_LINGUAS="cs da de es fr hr hu it ja nb nn pl pt ro ru sk sr sv tr zh_CN"
KDE_HANDBOOK="optional"
QT3SUPPORT_REQUIRED="true"
inherit kde4-base

DESCRIPTION="Graphical debugger interface"
HOMEPAGE="http://www.kdbg.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="sys-devel/gdb"
DEPEND="${RDEPEND}"

DOCS=( BUGS README ReleaseNotes-${PV} TODO )

src_prepare() {
	# allow documentation to be handled by eclass
	mv kdbg/doc . || die
	sed -i -e '/add_subdirectory(doc)/d' kdbg/CMakeLists.txt || die
	echo "add_subdirectory ( doc ) " >> CMakeLists.txt || die
	kde4-base_src_prepare
}

src_install() {
	kde4-base_src_install

	# hack since ChangeLog-* is automagically installed by eclass
	rm -f "${ED}"usr/share/doc/${PF}/ChangeLog-pre*
}
