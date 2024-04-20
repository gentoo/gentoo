# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-build

DESCRIPTION="Postfix Sender Rewriting Scheme forwarding agent"
EGO_PN="${PN}"
SRC_URI="https://github.com/zoni/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="https://github.com/zoni/postforward"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	dev-lang/go:0"
RDEPEND="
	mail-filter/postsrsd"

PATCHES=( "${FILESDIR}/${PN}_apply-sendmail-path.patch" )

src_prepare() {
	default

	# Dynamically fix EPREFIX lines made by ${PN}_apply-sendmail-path.patch
	sed -i -e "s/@GENTOO_PORTAGE_EPREFIX@/${EPREFIX}/" *.go || die

	# go build assumes files will be in src dir, but
	# source files are in root in this package, so move
	# them.
	local new_src_dir="${S}/src/${EGO_PN}"
	# Freak out if there's already something there because
	# it means the package has changed and we'll need to
	# adjust to it.
	[[ -e "${new_src_dir}" ]] && die "${new_src_dir} already exists"
	mkdir -p "${new_src_dir}" || die
	mv *.go "${new_src_dir}" || die
}

# Standard golang-build src_install complains about pkg not
# existing, so we go custom.
src_install() {
	einstalldocs
	dosbin "${PN}"
}
