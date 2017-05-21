# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} )

inherit distutils-r1 mercurial

DESCRIPTION="Python library to use Jabber/XMPP networks in a non-blocking way"
HOMEPAGE="http://python-nbxmpp.gajim.org/"
EHG_REPO_URI="https://hg.gajim.org/python-nbxmpp"

SLOT="0"
LICENSE="BSD"
IUSE=""

S="${WORKDIR}"/nbxmpp-${PV}
