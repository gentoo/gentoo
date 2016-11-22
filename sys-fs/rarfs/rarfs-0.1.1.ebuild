# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit python

DESCRIPTION="Fuse module to mount uncompressed RAR archives"
HOMEPAGE="https://sourceforge.net/projects/rarfs/"
SRC_URI="mirror://sourceforge/rarfs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-fs/fuse"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( README )

src_install() {
	install_prarfs() {
		python_convert_shebangs -q ${PYTHON_ABI} scripts/prarfs
		newbin scripts/prarfs prarfs-${PYTHON_ABI}
	}
	python_execute_function -q install_prarfs
	python_generate_wrapper_scripts "${ED}/usr/bin/prarfs"

	dobin src/rarfs
	dodoc ${DOCS[@]}
}
