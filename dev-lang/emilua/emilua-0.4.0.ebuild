#Mainainer:
#License available on https://www.boost.org/users/license.html

# USES STILL DON'T APPLY, ONLY FETCH DEPENDENCIES NEEDED.

EAPI=8
EGIT_REPO_URI="https://gitlab.com/emilua/emilua"
inherit git-r3
inherit meson
DESCRIPTION="Lua execution engine"


HOMEPAGE="http://emilua.org/"

SRC_URI="https://gitlab.com/emilua/emilua/-/archive/v0.4.0/emilua-v0.4.0.tar.gz -> emilua.tar.gz
         https://github.com/breese/trial.protocol/archive/79149f604a49b8dfec57857ca28aaf508069b669.tar.gz -> trial_protocol.tar.gz
		https://github.com/BoostGSoC14/boost.http/archive/93ae527c89ffc517862e1f5f54c8a257278f1195.tar.gz -> boost_http.tar.gz"

S=/var/tmp/portage/dev-lang/emilua-0.4.0/work/emilua-v0.4.0

LICENSE="Boost-1.0"

SLOT="0"

KEYWORDS="~amd64"

IUSE="color_output man"

RDEPEND="dev-lang/luajit[lua52compat]
	>=dev-libs/boost-1.81.0[context]
	dev-libs/serd
	dev-libs/sord
	sys-libs/liburing
	sys-libs/libcap
	>=dev-libs/libfmt-8.0.0"

DEPEND="sys-apps/gawk
	dev-vcs/git
	dev-util/gperf
	color_output? ( sys-libs/ncurses )
	man? ( dev-ruby/asciidoctor )"

BDEPEND="dev-util/re2c
    dev-util/meson
	app-editors/vim-core
	virtual/pkgconfig"

src_unpack(){
	unpack emilua.tar.gz
	unpack boost_http.tar.gz
	unpack trial_protocol.tar.gz
}

src_prepare(){
	cp -r "${WORKDIR}/boost.http-93ae527c89ffc517862e1f5f54c8a257278f1195/" "${WORKDIR}/emilua-v0.4.0/subprojects/"
	mv "${WORKDIR}/emilua-v0.4.0/subprojects/boost.http-93ae527c89ffc517862e1f5f54c8a257278f1195" "${WORKDIR}/emilua-v0.4.0/subprojects/emilua-http"
	cp -r "${WORKDIR}/trial.protocol-79149f604a49b8dfec57857ca28aaf508069b669/" "${WORKDIR}/emilua-v0.4.0/subprojects/trial-protocol"
	cp  "${WORKDIR}/emilua-v0.4.0/subprojects/packagefiles/trial.protocol/meson.build" "${WORKDIR}/emilua-v0.4.0/subprojects/trial-protocol/meson.build"
	cp  "${WORKDIR}/emilua-v0.4.0/subprojects/packagefiles/emilua-http/meson.build" "${WORKDIR}/emilua-v0.4.0/subprojects/emilua-http/meson.build"
	eapply_user
}

src_configure(){
	local emesonargs=(
	    -Ddisable_color=false
		#currently USE hardcode due to  upstream breakage
	    -Denable_manpages=true
	    -Denable_io_uring=true
	    -Denable_file_io=true
	    -Denable_http=true
		-Denable_linux_namespaces=true
		-Denable_tests=false
    )
	meson_src_configure
}
