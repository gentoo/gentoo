# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="sqlite"

inherit bash-completion-r1 python-single-r1 wrapper

DESCRIPTION="An automatic SQL injection and database takeover tool"
HOMEPAGE="https://sqlmap.org/"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/sqlmapproject/sqlmap"
else
	SRC_URI="https://github.com/sqlmapproject/sqlmap/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

# sqlmap (GPL-2+)
# ansitrm (BSD)
# beautifulsoup (BSD)
# bottle (MIT)
# chardet (LGPL-2.1+)
# clientform (BSD)
# colorama (BSD)
# fcrypt (BSD-2)
# identitywaf (MIT)
# keepalive (LGPL-2.1+)
# magic (MIT)
# multipartpost (LGPL-2.1+)
# ordereddict (MIT)
# prettyprint (BSD-2)
# pydes (public-domain)
# six (MIT)
# socks (BSD)
# termcolor (BSD)
# wininetpton (public-domain)
LICENSE="BSD BSD-2 GPL-2+ LGPL-2.1+ MIT public-domain"
SLOT="0"

RDEPEND="${PYTHON_DEPS}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DOCS=( doc/ README.md )

src_install () {
	einstalldocs

	insinto /usr/share/${PN}/
	doins -r *
	python_optimize "${ED}"/usr/share/${PN}

	make_wrapper ${PN} \
		"${EPYTHON} ${EPREFIX}/usr/share/${PN}/sqlmap.py"

	newbashcomp "${FILESDIR}"/sqlmap.bash-completion sqlmap
}
