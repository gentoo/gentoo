# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/bakefile/bakefile-0.2.9-r1.ebuild,v 1.1 2014/08/27 14:14:09 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 bash-completion-r1

DESCRIPTION="Native makefiles generator"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://bakefile.sourceforge.net"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=""
DEPEND=""

src_install () {
	default

	if use doc ; then
		dohtml -r doc/html/.
	fi

	# TODO: symlink the two
	newbashcomp bash_completion bakefile
	newbashcomp bash_completion bakefile_gen
}
