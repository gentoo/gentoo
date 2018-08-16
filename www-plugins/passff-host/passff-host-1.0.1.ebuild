# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_4 python3_5 python3_6 )

inherit python-single-r1

DESCRIPTION="Host app for the PassFF WebExtension"
HOMEPAGE="https://github.com/passff/passff-host"

# Using raw because of difference between git and release
# See https://github.com/passff/passff-host/issues/18
SRC_URI="
	https://github.com/passff/passff-host/raw/${PV}/src/passff.py -> ${P}.py
	https://github.com/passff/passff-host/raw/${PV}/src/passff.json -> ${P}.json
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="chrome chromium firefox vivaldi"
REQUIRED_USE="|| ( chrome chromium firefox vivaldi )"

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}/${P}.json" . || die
	cp "${DISTDIR}/${P}.py" . || die
}

src_prepare() {
	default

	sed -i "s/_VERSIONHOLDER_/${PV}/" "${P}.py" || die
	python_fix_shebang "${P}.py"
}

src_install() {
	local target_dirs=()

	use chrome   && target_dirs+=( "/etc/opt/chrome/native-messaging-hosts" )
	use chromium && target_dirs+=( "/etc/chromium/native-messaging-hosts" )
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
