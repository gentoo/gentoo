# Copyright 2018-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit python-single-r1

DESCRIPTION="Host app for the PassFF WebExtension"
HOMEPAGE="https://github.com/passff/passff-host"

SRC_URI="
	https://github.com/passff/passff-host/releases/download/${PV}/passff.py -> ${P}.py
	https://github.com/passff/passff-host/releases/download/${PV}/passff.json -> ${P}.json
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="chrome chromium +firefox vivaldi"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	|| ( chrome chromium firefox vivaldi )
"

RDEPEND="
	${PYTHON_DEPS}
	app-crypt/pinentry
"

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}/${P}.json" . || die
	cp "${DISTDIR}/${P}.py" . || die
}

src_prepare() {
	default
	python_fix_shebang "${P}.py"
}

src_install() {
	local target_dirs=()

	use chrome   && target_dirs+=( "/etc/opt/chrome/native-messaging-hosts" )
	use chromium && target_dirs+=( "/etc/chromium/native-messaging-hosts" )
	use firefox  && target_dirs+=( "/usr/$(get_libdir)/mozilla/native-messaging-hosts" )
	# www-client/firefox-bin compile-time dir is under /usr/lib/
	use firefox  && target_dirs+=( "/usr/lib/mozilla/native-messaging-hosts" )
	use vivaldi  && target_dirs+=( "/etc/vivaldi/native-messaging-hosts" )

	for target_dir in "${target_dirs[@]}"; do
		sed "s;PLACEHOLDER;${target_dir}/passff.py;g" "${P}.json" > "passff.json" || die

		insinto "${target_dir}"
		doins passff.json
		exeinto "${target_dir}"
		newexe "${P}.py" passff.py
	done
}

pkg_postinst() {
	elog "Make sure to use graphical version of pinentry for ${PN} to work properly"
	elog "Run 'eselect pinentry list'"
	elog "And select 'pinentry-qt5' or 'pinentry-gnome'. efl might work too."
}
