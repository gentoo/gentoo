# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit linux-info meson python-any-r1 systemd udev

DESCRIPTION="A load-balancing jobserver for Gentoo"
HOMEPAGE="https://gitweb.gentoo.org/proj/steve.git/"
SRC_URI="https://dev.gentoo.org/~mgorny/dist/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~s390 ~x86"
IUSE="debug test"
RESTRICT="test"
PROPERTIES="test? ( test_privileged )"

DEPEND="
	dev-libs/libevent:=
	sys-fs/fuse:3=
"
RDEPEND="
	${DEPEND}
	acct-group/jobserver
	acct-user/steve
	>=sys-fs/fuse-common-3.10.4-r2
"
BDEPEND="
	virtual/pkgconfig
	test? (
		$(python_gen_any_dep '
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pytest-timeout[${PYTHON_USEDEP}]
		')
	)
"

python_check_deps() {
	python_has_version "dev-python/pytest[${PYTHON_USEDEP}]" &&
		python_has_version "dev-python/pytest-timeout[${PYTHON_USEDEP}]"
}

pkg_pretend() {
	local CONFIG_CHECK="~CUSE"
	check_extra_config
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		$(meson_use !debug b_ndebug)
		$(meson_use test)
	)

	meson_src_configure
}

src_test() {
	addwrite /dev/cuse
	addwrite /dev/steve.test
	if [[ ! -w /dev/cuse ]]; then
		die "Testing steve requires /dev/cuse"
	fi

	local -x STEVE=${BUILD_DIR}/steve
	local EPYTEST_PLUGINS=( pytest-timeout )
	epytest
}

src_install() {
	meson_src_install

	# TODO: move these to meson
	systemd_dounit data/steve.service
	newconfd data/steve.confd steve
	newinitd data/steve.initd steve
	insinto /etc/sandbox.d
	newins data/sandbox.conf 90steve
	udev_newrules data/steve.udev 90-steve.rules
}

pkg_postinst() {
	udev_reload

	if ! grep -q -s -R -- '--jobserver-auth=fifo:/dev/steve' "${EROOT}"/etc/portage/make.conf
	then
		elog "In order to use the system-wide steve instance, enable the service:"
		elog
		elog "  systemctl enable --now steve"
		elog
		elog "Then add to your make.conf:"
		elog
		elog '  MAKEFLAGS="--jobserver-auth=fifo:/dev/steve"'
		elog '  NINJAOPTS=""'
		elog
		elog "You can use -l in NINJAOPTS but *do not* use -j, as it disables"
		elog "jobserver support."
	fi
}

pkg_postrm() {
	udev_reload
}
