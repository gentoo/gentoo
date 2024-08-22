# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..12} )

inherit python-single-r1 systemd toolchain-funcs

DESCRIPTION="Always-on profiling for production systems"
HOMEPAGE="https://0x.tools/
	https://github.com/tanelpoder/0xtools/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/tanelpoder/${PN}.git"
else
	SRC_URI="https://github.com/tanelpoder/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
"
BDEPEND="
	${RDEPEND}
"

DOCS=( CHANGELOG.md README.md )

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} ${LDFLAGS}"

	sed -e "/^sys.path.append/s|(.*)|('$(python_get_sitedir)/${PN}')|"	\
		-i bin/psn -i bin/schedlat || die
}

src_install() {
	# C executables and scripts
	exeinto /usr/bin
	doexe bin/{cpumhz,cpumhzturbo,vmtop,xcapture,xtop}
	doexe bin/{run_xcapture.sh,run_xcpu.sh}

	# Python executables
	python_domodule "lib/${PN}"
	python_doscript bin/psn
	python_doscript bin/schedlat
	python_doscript bin/syscallargs

	# Service
	systemd_dounit xcapture.service
	systemd_dounit xcapture-restart.service
	systemd_dounit xcapture-restart.timer

	# Service config
	insinto /etc/default
	newins xcapture.default xcapture

	# Service logs
	keepdir /var/log/xcapture

	einstalldocs
}
