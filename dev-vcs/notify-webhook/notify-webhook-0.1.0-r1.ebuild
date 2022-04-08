# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 )

inherit python-single-r1

DESCRIPTION="Git post-receive web hook notifier in Python"
HOMEPAGE="https://github.com/metajack/notify-webhook"
#COMMIT='c571160f155122446e97bb01c1150b4d14ea69d6'
SRC_URI="https://github.com/metajack/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="dev-python/simplejson"
RDEPEND="${DEPEND} ${PYTHON_DEPS}"

#MY_P="${PN}-${COMMIT}"
#S="${WORKDIR}/${MY_P}"

src_install() {
	dodoc *markdown
	exeinto /usr/libexec/githook/${PN}/
	doexe notify-webhook.py
}
