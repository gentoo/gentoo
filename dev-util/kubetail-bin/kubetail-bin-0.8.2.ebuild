# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Real-time logging dashboard for Kubernetes"
HOMEPAGE="https://www.kubetail.com"

SRC_URI="
amd64? ( https://github.com/kubetail-org/kubetail/releases/download/cli%2Fv${PV}/kubetail-linux-amd64
-> ${P}-linux-amd64 )
arm64? ( https://github.com/kubetail-org/kubetail/releases/download/cli%2Fv${PV}/kubetail-linux-arm64
-> ${P}-linux-arm64 )
"

S=${WORKDIR}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="strip"

QA_PREBUILT="usr/bin/kubetail"
inherit shell-completion

src_install() {
	cp "${DISTDIR}/${P}-linux-${ARCH}" "${T}/kubetail" || die
	chmod +x "${T}/kubetail" || die

	dobin "${T}/kubetail" || die

	# If the binary can generate completions at build time, do it:
	if "${T}/kubetail" completion bash >/dev/null 2>&1 ; then
		"${T}/kubetail" completion bash > "${T}/kubetail.bash" || die
		"${T}/kubetail" completion zsh > "${T}/kubetail.zsh" || die
		"${T}/kubetail" completion fish > "${T}/kubetail.fish" || die

		newbashcomp "${T}/kubetail.bash" kubetail
		newzshcomp "${T}/kubetail.zsh" "_kubetail"
		dofishcomp "${T}/kubetail.fish"
	else
		ewarn "Shell completions not generated at build-time. Users can run '${PN} completion --help'."
	fi
}
