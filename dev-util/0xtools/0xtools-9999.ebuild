# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..12} )

inherit python-single-r1 systemd toolchain-funcs wrapper

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

BDEPEND="
	${PYTHON_DEPS}
"
RDEPEND="
	${BDEPEND}
	sys-power/cpupower
	$(python_gen_cond_dep '
		dev-util/bcc[${PYTHON_USEDEP}]
	')
"

DOCS=( CHANGELOG.md README.md )

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} ${LDFLAGS}"

	sed -e "/^sys.path.append/s|(.*)|('$(python_get_sitedir)/${PN}')|"	\
		-i bin/psn -i bin/schedlat || die
}

src_install() {
	# "cpumhzturbo" requires "turbostat", which is not packaged,
	# see bug: https://bugs.gentoo.org/939913

	# C executables and scripts
	exeinto /usr/bin
	doexe bin/{cpumhz,vmtop,xcapture,xtop}
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

	# Setup for "xcapture-bpf".
	exeinto "/lib/${PN}/xcapture"
	doexe bin/xcapture-bpf
	insinto "/lib/${PN}/xcapture"
	doins bin/xcapture-bpf.c
	make_wrapper xcapture-bpf "/lib/${PN}/xcapture/xcapture-bpf"

	# Service config
	insinto /etc/default
	newins xcapture.default xcapture

	# Service logs
	keepdir /var/log/xcapture

	einstalldocs
}
