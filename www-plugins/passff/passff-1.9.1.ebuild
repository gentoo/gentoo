# Copyright 2018-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_XPINAME="${P}-fx"

DESCRIPTION="zx2c4 pass manager extension for Firefox"
HOMEPAGE="https://github.com/passff/passff"
SRC_URI="https://addons.mozilla.org/firefox/downloads/file/3051801/${MY_XPINAME}.xpi"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="www-plugins/passff-host[firefox]"

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}/${MY_XPINAME}.xpi" . || die
}

src_install() {
	# See https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Distribution_options/Sideloading_add-ons#Installation_using_the_standard_extension_folders
	insinto "/usr/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/"
	# passff@invicem.pro is the extension id found in the manifest.json
	newins "${MY_XPINAME}.xpi" "passff@invicem.pro.xpi"
}
