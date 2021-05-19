# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1

HEX_PACKAGES="
	bbmustache-1.10.0
	certifi-2.6.1
	cf-0.3.1
	cth_readable-1.5.1
	erlware_commons-1.5.0
	eunit_formatters-0.5.0
	getopt-1.0.1
	meck-0.8.13
	providers-1.8.1
	relx-4.4.0
	ssl_verify_fun-1.1.6
"

hex_package_uris() {
	local package
	for package in "$@"; do
		echo "https://repo.hex.pm/tarballs/${package}.tar -> ${package}.hex.tar"
	done
}

DESCRIPTION="Erlang build tool that makes it easy to build and test applications and releases"
HOMEPAGE="https://www.rebar3.org/ https://github.com/erlang/rebar3/"
SRC_URI="https://github.com/erlang/rebar3/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://distfiles.matthew.run/dev-util/rebar/${PV}/packages.idx.xz -> ${P}-packages.idx.xz
	$(hex_package_uris ${HEX_PACKAGES})"
S="${WORKDIR}/rebar3-${PV}"

LICENSE="Apache-2.0 MIT BSD"
SLOT="3"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	dev-lang/erlang:=
	!dev-util/rebar-bin
"
DEPEND="${RDEPEND}"

src_unpack() {
	local archive
	for archive in ${A}; do
		case "${archive}" in
			*.hex.tar)
				ebegin "Unpacking ${archive}"

				local dest

				if [[ "${archive%-*}" == "meck" ]]; then
					dest="${S}/_build/test/lib/${archive%-*}"
				else
					dest="${S}/_build/default/lib/${archive%-*}"
				fi

				mkdir -p "$dest" || die
				tar -O -xf "${DISTDIR}/${archive}" contents.tar.gz |
					tar -xzf - -C "${dest}" || die

				eend $?
				;;
			*)
				unpack "${archive}"
				;;
		esac
	done

	local hex_cache_dir="${HOME}/.cache/rebar3/hex"
	mkdir -p "${hex_cache_dir}" || die
	mv "${WORKDIR}/${P}-packages.idx" "${hex_cache_dir}/packages.idx" || die
}

src_compile() {
	./bootstrap || die
}

src_test() {
	./rebar3 ct || die
}

src_install() {
	dobashcomp priv/shell-completion/bash/rebar3
	dobin rebar3
	dodoc rebar.config.sample
	doman manpages/rebar3.1
}
