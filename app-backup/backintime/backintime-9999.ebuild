# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit python-single-r1 git-r3 xdg

DESCRIPTION="Backup system inspired by TimeVault and FlyBack"
HOMEPAGE="https://backintime.readthedocs.io/en/latest/ https://github.com/bit-team/backintime/"
EGIT_REPO_URI="https://github.com/bit-team/backintime/"

LICENSE="GPL-2"
SLOT="0"
IUSE="examples qt5"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/keyring[${PYTHON_USEDEP}]
	')"
RDEPEND="${DEPEND}
	net-misc/openssh
	net-misc/rsync[xattr,acl]
	qt5? ( dev-python/PyQt5[gui,widgets] )"
BDEPEND="sys-devel/gettext"

PATCHES=( "${FILESDIR}/${PN}-1.2.1-no-compress-docs-examples.patch" )

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
	pushd common > /dev/null || die
	emake
	popd > /dev/null || die

	if use qt5 ; then
		pushd qt > /dev/null || die
		emake
		popd > /dev/null || die
	fi
}

src_install() {
	pushd common > /dev/null || die
	emake DESTDIR="${D}" install
	popd > /dev/null || die

	if use qt5 ; then
		pushd qt > /dev/null || die
		emake DESTDIR="${D}" install
		popd > /dev/null || die
	fi

	einstalldocs

	if use examples ; then
		docinto examples
		dodoc common/{config-example-local,config-example-ssh}
	fi

	python_optimize "${D}"
}
