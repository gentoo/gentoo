# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit python-single-r1 xdg

DESCRIPTION="Backup system inspired by TimeVault and FlyBack"
HOMEPAGE="https://backintime.readthedocs.io/en/latest/ https://github.com/bit-team/backintime/"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/bit-team/backintime/"
	inherit git-r3
else
	SRC_URI="https://github.com/bit-team/${PN}/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="examples qt5 test"
RESTRICT="!test? ( test )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/keyring[${PYTHON_USEDEP}]
	')
"
RDEPEND="
	${DEPEND}
	virtual/openssh
	net-misc/rsync[xattr,acl]
	qt5? ( dev-python/PyQt5[gui,widgets] )
"
BDEPEND="
	sys-devel/gettext
	test? (
		$(python_gen_cond_dep '
			dev-python/pyfakefs[${PYTHON_USEDEP}]
		')
	)
"

PATCHES=( "${FILESDIR}/${PN}-1.2.1-no-compress-docs-examples.patch" )

src_prepare() {
	default

	# Looks at host system too much, so too flaky
	rm common/test/test_tools.py || die
	# Fails with dbus/udev issue (likely sandbox)
	rm common/test/test_snapshots.py || die
}

src_configure() {
	pushd common > /dev/null || die
	# Not autotools
	./configure --python3 --no-fuse-group || die
	popd > /dev/null || die

	if use qt5 ; then
		pushd qt > /dev/null || die
		./configure --python3 || die
		popd > /dev/null || die
	fi
}

src_compile() {
	emake -C common

	if use qt5 ; then
		emake -C qt
	fi
}

src_test() {
	# pytest should work but it can't find the backintime binary, so
	# use the unittest-based runner instead.
	# https://github.com/bit-team/backintime/blob/dev/CONTRIBUTING.md#how-to-contribute-to-back-in-time
	emake -C common test-v
}

src_install() {
	emake -C common DESTDIR="${D}" install

	if use qt5 ; then
		emake -C qt DESTDIR="${D}" install
	fi

	einstalldocs

	if use examples ; then
		docinto examples
		dodoc common/{config-example-local,config-example-ssh}
	fi

	python_optimize "${D}"
}
