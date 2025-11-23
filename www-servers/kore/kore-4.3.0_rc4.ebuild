# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

APP_PV="${PV/_/-}"

inherit toolchain-funcs

DESCRIPTION="Web application platform for writing scalable, concurrent web based processes"
HOMEPAGE="https://kore.io/
	https://github.com/jorisvink/kore/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://git.kore.io/kore"
else
	SRC_URI="https://github.com/jorisvink/${PN}/archive/refs/tags/${APP_PV}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-${APP_PV}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="ISC"
SLOT="0"
IUSE="+acme +curl debug +http +json +openssl postgres +threads"
REQUIRED_USE="acme? ( curl openssl )"

RDEPEND="
	curl? ( net-misc/curl:= )
	json? ( dev-libs/yajl:= )
	openssl? ( dev-libs/openssl:= )
	postgres? ( dev-db/postgresql:= )
"
DEPEND="
	${RDEPEND}
"

PATCHES=(
	"${FILESDIR}/kore-4.2.3-makefile.patch"
	"${FILESDIR}/kore-4.2.3-kodev-makefile.patch"
)

DOCS=( README.md )

src_prepare() {
	default

	sed -i ./kodev/Makefile tools/kore-serve/conf/build.conf \
		-e 's|-Werror||g' \
		|| die
}

src_compile() {
	tc-export CC

	# See https://github.com/jorisvink/kore#building-kore
	env ACME=$(usex acme 1 '')                      \
		CURL=$(usex curl 1 '')                      \
		DEBUG=$(usex debug 1 '')                    \
		JSONRPC=$(usex json 1 '')                   \
		NOHTTP=$(usex http '' 1)                    \
		PGSQL=$(usex postgres 1 '')                 \
		TASKS=$(usex threads 1 '')                  \
		TLS_BACKEND=$(usex openssl openssl none)    \
		CFLAGS="${CFLAGS} ${LDFLAGS}"               \
		LDFLAGS="${LDFLAGS}"                        \
		PREFIX=/usr                                 \
		emake
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install

	einstalldocs
}
