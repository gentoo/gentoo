# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=dartsdk

DESCRIPTION="The Dart SDK, including the VM, dart2js, core libraries, and more"
HOMEPAGE="https://dart.dev/"
MY_BASE_URI="https://storage.googleapis.com/dart-archive/channels/stable/release/${PV}/sdk"
SRC_URI="
	amd64? ( ${MY_BASE_URI}/${MY_PN}-linux-x64-release.zip -> ${P}_amd64.zip )
"
S="${WORKDIR}/dart-sdk"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-* ~amd64"

BDEPEND="app-arch/unzip"

QA_PRESTRIPPED="/opt/${PN}/bin/.*"

src_install() {
	insinto /opt/${PN}
	doins -r bin include lib dartdoc_options.yaml revision version
	fperms +x opt/${PN}/bin/{dart,dartaotruntime}
	fperms +x opt/${PN}/bin/resources/devtools/canvaskit/canvaskit.{js{,.symbols},wasm}
	dosym -r /opt/${PN}/bin/dart /usr/bin/dart
}
