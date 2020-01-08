# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7} )
DISTUTILS_SINGLE_IMPL=1

inherit bash-completion-r1 distutils-r1

DESCRIPTION="Next generation Debian package upload tool"
HOMEPAGE="https://people.debian.org/~paultag/dput-ng/"
SRC_URI="mirror://debian/pool/main/d/${PN}/${PN}_${PV}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-python/python-debian[${PYTHON_USEDEP}]
	dev-python/paramiko[${PYTHON_USEDEP}]
	dev-util/distro-info[python,${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	app-text/asciidoc
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/python-debian[${PYTHON_USEDEP}]
		dev-util/debhelper
	)"

# Requires missing build-essential package
RESTRICT="test"

src_compile() {
	distutils-r1_src_compile

	mkdir man || die
	for file in docs/man/*.man; do
		a2x --doctype manpage --format manpage -D man \
			"${file}" || die
	done
}

src_install() {
	local DPUT_BINARIES=( dcut dirt dput )
	local DPUT_ETC=( metas profiles )
	local DPUT_SHARE=(
		codenames
		commands
		hooks
		interfaces
		schemas
		uploaders
	)

	distutils-r1_src_install

	for binary in ${DPUT_BINARIES[@]}; do
		dobin bin/"${binary}"
	done
	python_fix_shebang "${D}"/usr/bin

	insinto /etc/dput.d
	for dir in ${DPUT_ETC[@]}; do
		doins -r skel/"${dir}"
	done

	insinto /usr/share/"${PN}"
	for dir in ${DPUT_SHARE[@]}; do
		doins -r skel/"${dir}"
	done

	# doman incorrectly treats "cf" in dput.cf.5 as a lang code
	doman -i18n="" man/*

	newbashcomp debian/dcut-completion dcut
	newbashcomp debian/dput-completion dput
}

python_test() {
	# test_configs.py failing
	# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=824652
	nosetests || die "Tests failed under ${EPYTHON}"
}
