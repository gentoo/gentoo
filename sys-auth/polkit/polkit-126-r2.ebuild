# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
inherit meson pam pax-utils python-any-r1 systemd tmpfiles xdg-utils

DESCRIPTION="Policy framework for controlling privileges for system-wide services"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/polkit https://github.com/polkit-org/polkit"
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/polkit-org/polkit"
	inherit git-r3
elif [[ ${PV} == *_p* ]] ; then
	# Upstream don't make releases very often. Test snapshots throughly
	# and review commits, but don't shy away if there's useful stuff there
	# we want.
	MY_COMMIT=""
	SRC_URI="https://github.com/polkit-org/polkit/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

	S="${WORKDIR}"/${PN}-${MY_COMMIT}
else
	SRC_URI="https://github.com/polkit-org/polkit/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="LGPL-2"
SLOT="0"
if [[ ${PV} != 9999 ]] ; then
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"
fi
IUSE="examples gtk +introspection kde pam nls selinux systemd test"
RESTRICT="!test? ( test )"

BDEPEND="
	acct-user/polkitd
	app-text/docbook-xml-dtd:4.1.2
	app-text/docbook-xsl-stylesheets
	>=dev-libs/glib-2.32
	dev-libs/gobject-introspection-common
	dev-libs/libxslt
	dev-util/glib-utils
	virtual/pkgconfig
	introspection? ( >=dev-libs/gobject-introspection-0.6.2 )
	nls? ( sys-devel/gettext )
	test? (
		$(python_gen_any_dep '
			dev-python/dbus-python[${PYTHON_USEDEP}]
			dev-python/python-dbusmock[${PYTHON_USEDEP}]
		')
	)
"
DEPEND="
	>=dev-libs/glib-2.32:2
	dev-libs/expat
	dev-lang/duktape:=
	pam? (
		sys-auth/pambase
		sys-libs/pam
	)
	!pam? ( virtual/libcrypt:= )
	systemd? ( sys-apps/systemd:0=[policykit] )
	!systemd? ( sys-auth/elogind )
"
RDEPEND="
	${DEPEND}
	acct-user/polkitd
	selinux? ( sec-policy/selinux-policykit )
"
PDEPEND="
	gtk? ( || (
		>=gnome-extra/polkit-gnome-0.105
		>=lxde-base/lxsession-0.5.2
	) )
	kde? ( kde-plasma/polkit-kde-agent )
"

DOCS=( docs/TODO HACKING.md NEWS.md README.md )

QA_MULTILIB_PATHS="
	usr/lib/polkit-1/polkit-agent-helper-1
	usr/lib/polkit-1/polkitd
"

PATCHES=(
	"${FILESDIR}"/${P}-elogind.patch
)

python_check_deps() {
	python_has_version "dev-python/dbus-python[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/python-dbusmock[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	default

	# bug #401513
	sed -i -e 's|unix-group:@PRIVILEGED_GROUP@|unix-user:@PRIVILEGED_GROUP@|' src/polkitbackend/*-default.rules.in || die
}

src_configure() {
	xdg_environment_reset

	local emesonargs=(
		--localstatedir="${EPREFIX}"/var
		-Dauthfw="$(usex pam pam shadow)"
		-Dexamples=false
		-Dgtk_doc=false
		-Dman=true
		-Dos_type=gentoo
		-Dpam_module_dir=$(getpam_mod_dir)
		-Dprivileged_group=0
		-Dsession_tracking="$(usex systemd logind elogind)"
		-Dsystemdsystemunitdir="$(systemd_get_systemunitdir)"
		-Dlibs-only=false
		$(meson_use introspection)
		$(meson_use nls gettext)
		$(meson_use test tests)
	)
	meson_src_configure
}

src_compile() {
	meson_src_compile

	# Required for polkitd on hardened/PaX due to spidermonkey's JIT
	pax-mark mr src/polkitbackend/.libs/polkitd test/polkitbackend/.libs/polkitbackendjsauthoritytest
}

src_install() {
	meson_src_install

	# acct-user/polkitd installs its own (albeit with a different filename)
	rm -rf "${ED}"/usr/lib/sysusers.d || die

	if use examples ; then
		docinto examples
		dodoc src/examples/{*.c,*.policy*}
	fi

	if [[ ${EUID} == 0 ]]; then
		diropts -m 0700 -o polkitd
	fi
	keepdir /etc/polkit-1/rules.d
}

pkg_postinst() {
	tmpfiles_process polkit-tmpfiles.conf

	if [[ ${EUID} == 0 ]]; then
		chmod 0700 "${EROOT}"/{etc,usr/share}/polkit-1/rules.d
		chown polkitd "${EROOT}"/{etc,usr/share}/polkit-1/rules.d
	fi
}
