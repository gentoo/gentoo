# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-env go-module eapi9-ver

DESCRIPTION="Pager designed to do the right thing without any configuration"
HOMEPAGE="https://github.com/walles/moor"
SRC_URI="https://github.com/walles/moor/archive/refs/tags/v${PV}.tar.gz -> moor-${PV}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/moor/moor-${PV}-deps.tar.xz"

LICENSE="BSD-2 BSD MIT"
# Dependent licenses
LICENSE+="  Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64"
IUSE="test l10n_ru"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		app-arch/bzip2
		app-arch/xz-utils
	)
"

src_unpack() {
	default

	if [[ -d "${WORKDIR}"/vendor ]] ; then
		mv "${WORKDIR}"/vendor "${S}"/vendor || die
	fi
	go-env_set_compile_environment
}

src_compile() {
	# https://github.com/walles/moor/blob/master/build.sh#L28
	ego build -ldflags="-w -X main.versionString=${PV}" -o moor ./cmd/moor
}

src_test() {
	# From test.sh (we don't run that because it has some linting etc)
	ego test -timeout 20s ./...
}

src_install() {
	dobin moor
	doman moor.1
	einstalldocs
}

pkg_postinst() {
	if use l10n_ru ; then
		ewarn "This package does not work out of the box with all Russian locales."
		ewarn "If using ru_RU.UTF-8, it will not startup. Please see bug #964663."
	fi

	if ver_replacing -lt 2 ; then
		ewarn "moar has been renamed to moor, please update any scripts."
	fi
}
