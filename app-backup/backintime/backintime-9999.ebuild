# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
inherit python-single-r1 xdg

DESCRIPTION="Backup system inspired by TimeVault and FlyBack"
HOMEPAGE="https://backintime.readthedocs.io/en/latest/ https://github.com/bit-team/backintime/"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/bit-team/backintime/"
	inherit git-r3
else
	SRC_URI="https://github.com/bit-team/${PN}/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="examples gui test"
RESTRICT="!test? ( test )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/keyring[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
	')
"
RDEPEND="
	${DEPEND}
	virtual/openssh
	net-misc/rsync[xattr,acl]
	gui? ( dev-python/pyqt6[gui,widgets] )
"
BDEPEND="
	sys-devel/gettext
	test? ( $(python_gen_cond_dep 'dev-python/pyfakefs[${PYTHON_USEDEP}]') )
"

PATCHES=(
	"${FILESDIR}/${PN}-1.5.4-no-compress-docs-examples.patch"
	"${FILESDIR}/${PN}-1.5.4-crontab-systemd.patch"
)

src_prepare() {
	default

	# Looks at host system too much, so too flaky
	rm common/test/test_tools.py || die
	# Fails with dbus/udev issue (likely sandbox)
	rm common/test/test_snapshots.py || die
}

src_configure() {
	# TODO: Review https://github.com/bit-team/backintime/blob/dev/CONTRIBUTING.md#dependencies
	# for deps (some may be optfeatures).
	pushd common > /dev/null || die
	# Not autotools
	./configure --python="${PYTHON}" --no-fuse-group || die
	popd > /dev/null || die

	if use gui ; then
		pushd qt > /dev/null || die
		./configure --python="${PYTHON}" || die
		popd > /dev/null || die
	fi
}

src_compile() {
	emake -C common

	use gui && emake -C qt
}

src_test() {
	# https://github.com/bit-team/backintime/blob/dev/CONTRIBUTING.md#testing
	EPYTEST_IGNORE=(
		# We're not interested in linting tests for our purposes
		test/test_lint.py
	)

	(
		EPYTEST_DESELECT+=(
			# Wants a crontab
			test/test_backintime.py::BackInTime::test_quiet_mode
		)
		EPYTEST_IGNORE+=(
			# Wants an SSH key
			test/test_sshtools.py
		)

		cd common || die
		epytest
	)

	use gui && (
		cd qt || die
		epytest
	)
}

src_install() {
	emake -C common DESTDIR="${D}" install

	if use gui; then
		emake -C qt DESTDIR="${D}" install
	fi

	einstalldocs

	if use examples ; then
		docinto examples
		dodoc common/{config-example-local,config-example-ssh}
	fi

	python_optimize "${D}"
}
