# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"opt/libreoffice7.1/share/extensions/dict-hu/hu_HU.aff"
	"opt/libreoffice7.1/share/extensions/dict-hu/hu_HU.dic"
)

MYSPELL_HYPH=(
	"opt/libreoffice7.1/share/extensions/dict-hu/hyph_hu_HU.dic"
)

MYSPELL_THES=(
	"opt/libreoffice7.1/share/extensions/dict-hu/th_hu_HU_v2.dat"
	"opt/libreoffice7.1/share/extensions/dict-hu/th_hu_HU_v2.idx"
)

inherit rpm myspell-r2

DESCRIPTION="Hungarian dictionaries for myspell/hunspell"
HOMEPAGE="http://magyarispell.sourceforge.net/"
SRC_URI="https://downloadarchive.documentfoundation.org/libreoffice/old/7.1.3.2/rpm/x86_64/LibreOffice_7.1.3.2_Linux_x86-64_rpm_langpack_hu.tar.gz"

LICENSE="GPL-3 GPL-2 LGPL-2.1 MPL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE=""

src_unpack() {
	myspell-r2_src_unpack

	rpm_unpack ./LibreOffice_7.1.3.2_Linux_x86-64_rpm_langpack_hu/RPMS/libreoffice7.1-dict-hu-7.1.3.2-2.x86_64.rpm
}
