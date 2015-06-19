# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/backports/backports-1.0.ebuild,v 1.12 2015/04/08 08:05:17 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Namespace for backported Python features"
HOMEPAGE="https://bitbucket.org/brandon/backports https://pypi.python.org/pypi/backports/"
SRC_URI="http://dev.gentoo.org/~radhermit/dist/${P}.tar.gz"

LICENSE="PYTHON"
SLOT="0"
KEYWORDS="amd64 arm hppa ppc ppc64 x86 ~amd64-linux ~x86-linux"

RDEPEND="!<dev-python/backports-lzma-0.0.2-r1"
