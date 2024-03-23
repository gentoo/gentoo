# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby31 ruby32"

inherit desktop ruby-ng

PLUGIN_HASH="30071c3008e4616e723cf4e734fc79254019af09"
BLOWFISH_PATCH_NAME="1585-use-own-blowfish-impl.patch"
BLOWFISH_PATCH_URI="https://dev.mikutter.hachune.net/attachments/download/813/${BLOWFISH_PATCH_NAME}"

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="git://mikutter.hachune.net/mikutter.git"
	inherit git-r3
	SRC_URI=" ${BLOWFISH_PATCH_URI}"
	EGIT_CHECKOUT_DIR="${WORKDIR}/all"
else
	SRC_URI="http://mikutter.hachune.net/bin/${P}.tar.gz
		${BLOWFISH_PATCH_URI}"
	KEYWORDS="~amd64 ~riscv"
fi

DESCRIPTION="Simple, powerful and moeful twitter client"
HOMEPAGE="https://mikutter.hachune.net/"

# Apache license for the blowfish patch
# https://dev.mikutter.hachune.net/issues/1585
LICENSE="Apache-2.0 MIT"
SLOT="0"
IUSE="+libnotify"

PATCHES=(
	"${DISTDIR}/${BLOWFISH_PATCH_NAME}"
)

DEPEND=""
RDEPEND="
	libnotify? ( x11-libs/libnotify )
	media-sound/alsa-utils"

ruby_add_rdepend "=dev-ruby/addressable-2.8*
	>=dev-ruby/delayer-1.2.1
	!>=dev-ruby/delayer-2.0
	>=dev-ruby/delayer-deferred-2.2.0
	!>=dev-ruby/delayer-deferred-3.0
	>=dev-ruby/diva-2.0.1
	!>=dev-ruby/diva-3.0
	dev-ruby/httpclient
	dev-ruby/json:2
	>=dev-ruby/memoist-0.16.2
	!>=dev-ruby/memoist-0.17
	dev-ruby/moneta
	dev-ruby/nokogiri
	>=dev-ruby/oauth-0.5.8
	>=dev-ruby/pluggaloid-1.7.0
	!>=dev-ruby/pluggaloid-2.0
	=dev-ruby/prime-0.1.2*
	dev-ruby/rcairo
	>=dev-ruby/ruby-gettext-3.4
	!>=dev-ruby/ruby-gettext-3.5
	dev-ruby/ruby-gtk3
	>=dev-ruby/typed-array-0.1.2
	!>=dev-ruby/typed-array-0.2
	virtual/ruby-ssl"

all_ruby_unpack() {
	if [ "${PV}" = "9999" ];then
		git-3_src_unpack
	else
		default
	fi
}

all_ruby_install() {
	local ruby

	for ruby in ${RUBY_TARGETS_PREFERENCE}; do
		if use ruby_targets_${ruby}; then
			break
		fi
	done

	exeinto /usr/share/mikutter
	doexe mikutter.rb
	insinto /usr/share/mikutter
	doins -r core plugin
	sed -e "s/ruby19/${ruby}/" "${FILESDIR}"/mikutter \
		| newbin - mikutter
	dodoc README
	make_desktop_entry mikutter Mikutter \
		/usr/share/mikutter/core/skin/data/icon.png
}
