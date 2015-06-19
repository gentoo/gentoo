# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pychecker/pychecker-0.8.19-r1.ebuild,v 1.9 2015/02/28 13:40:26 ago Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python source code checking tool"
HOMEPAGE="http://pychecker.sourceforge.net/ http://pypi.python.org/pypi/PyChecker"
SRC_URI="mirror://sourceforge/pychecker/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

DOCS=( pycheckrc ChangeLog KNOWN_BUGS MAINTAINERS NEWS README TODO )

PATCHES=(
	"${FILESDIR}"/${P}-version.patch
	"${FILESDIR}"/${P}-create_script.patch
	)

python_prepare_all() {
	sed \
		-e '1d' \
		-i pychecker/checker.py \
		|| die

	# Disable installation of unneeded files.
	sed \
		-e "/'data_files'       :/d" \
		-i setup.py || die "sed failed"

	# Strip final "/" from root.
	sed \
		-e 's:root = self\.distribution\.get_command_obj("install")\.root:&\.rstrip("/"):' \
		-i setup.py || die "sed failed"

	distutils-r1_python_prepare_all
}
