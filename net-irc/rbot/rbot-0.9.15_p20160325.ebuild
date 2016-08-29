# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

GITHUB_COMMIT="e358601cc521d8aced941eb928fae2d8c53cf0c2"
inherit ruby-ng eutils user

DESCRIPTION="A ruby IRC bot"
HOMEPAGE="http://ruby-rbot.org/"
SRC_URI="https://github.com/ruby-rbot/rbot/archive/${GITHUB_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( feh GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="spell aspell timezone translator shorturl nls figlet
	fortune cal host toilet"
ILINGUAS="zh_CN zh_TW ru nl de fi fr it ja"
RUBY_S="${PN}-${GITHUB_COMMIT}"

for lang in $ILINGUAS; do
	IUSE="${IUSE} linguas_${lang}"
done

RUBY_PATCHES=( rbot-rakefile-gettext.patch )

RDEPEND+="
	spell? (
		aspell? ( app-text/aspell )
		!aspell? ( app-text/hunspell )
	)
	figlet? ( app-misc/figlet )
	toilet? ( app-misc/toilet )
	fortune? ( games-misc/fortune-mod )
	cal? ( || ( sys-apps/util-linux sys-freebsd/freebsd-ubin ) )
	host? ( net-dns/bind-tools )"

ruby_add_bdepend "
	nls? (
		>=dev-ruby/ruby-gettext-2
		dev-ruby/rake
	)"

ruby_add_rdepend "
	dev-ruby/tokyocabinet
	timezone? ( dev-ruby/tzinfo:* )
	translator? ( dev-ruby/mechanize )
	shorturl? ( dev-ruby/shorturl )
	nls? ( dev-ruby/ruby-gettext >=dev-ruby/locale-2.0.5-r2 )
"

pkg_setup() {
	enewuser rbot -1 -1 /var/lib/rbot nobody
}

all_ruby_prepare() {
	# Avoid tests that are only compatible with ruby22
	rm -f test/test_journal.rb || die

	# Fix deprecated code that was removed with ruby22
	sed -i -e 's/::Config/::RbConfig/' setup.rb || die
}

all_ruby_compile() {
	disable_rbot_plugin() {
		mv "${S}"/data/rbot/plugins/$1.rb{,.disabled}
	}
	use_rbot_plugin() {
		use $1 && return
		disable_rbot_plugin "$2"
	}
	rbot_conf() {
		echo "$1: $2" >> "${T}"/rbot.conf
	}
	use_rbot_conf_path() {
		use "$1" \
			&& rbot_conf "$2" "$3" \
			|| rbot_conf "$2" /bin/false
	}

	local spell_program="/usr/bin/hunspell -i"
	if use !spell; then
		disable_rbot_plugin spell
		spell_program="/bin/false"
	elif use aspell; then
		spell_program="/usr/bin/ispell-aspell"
	fi

	rbot_conf spell.program "${spell_program}"

	if use !figlet && use !toilet; then
		disable_rbot_plugin figlet
	fi

	use_rbot_conf_path figlet figlet.path /usr/bin/figlet
	use_rbot_conf_path toilet toilet.path /usr/bin/toilet

	use_rbot_plugin timezone time
	use_rbot_plugin translator translator
	use_rbot_plugin shorturl shortenurls

	use_rbot_plugin fortune fortune
	use_rbot_conf_path fortune fortune.path /usr/bin/fortune

	use_rbot_plugin cal cal
	use_rbot_conf_path cal cal.path /usr/bin/cal

	use_rbot_plugin host host
	use_rbot_conf_path host host.path /usr/bin/host

	local rbot_datadir="${D}"/usr/share/rbot

	# This is unfortunately pretty manual at the moment, but it's just
	# to avoid having to run special scripts to package new versions
	# of rbot. The default if new languages are added that are not
	# considered for an opt-out here is to install them, so you just
	# need to add them later.
	if use nls; then
		strip-linguas ${ILINGUAS}
		if [[ -n ${LINGUAS} ]]; then
			# As the the language name used by the rbot data files does
			# not correspond to the ISO codes we usually use for LINGUAS,
			# the following list of local varables will work as a
			# dictionary to get the name used by rbot from the ISO code.
			local lang_rbot_zh_CN="traditional_chinese"
			local lang_rbot_ru="russian"
			local lang_rbot_nl="dutch"
			local lang_rbot_de="german"
			local lang_rbot_fi="finnish"
			local lang_rbot_fr="french"
			local lang_rbot_it="italian"
			local lang_rbot_ja="japanese"

			for lang in ${ILINGUAS}; do
				use linguas_${lang} && continue

				lang_varname="lang_rbot_${lang}"
				lang_rbot=${!lang_varname}

				rm -r \
					"${S}"/data/rbot/languages/${lang_rbot}.lang \
					"${S}"/data/rbot/templates/lart/larts-${lang_rbot} \
					"${S}"/data/rbot/templates/lart/praises-${lang_rbot} \
					"${S}"/data/rbot/templates/salut/salut-${lang_rbot} \
					"${S}"/po/${lang} &>/dev/null
			done
		fi

		${RUBY} /usr/bin/rake makemo || die "locale generation failed"
	fi
}

each_ruby_compile() {
	${RUBY} setup.rb config --prefix="/usr" \
		|| die "setup.rb install failed"
}

each_ruby_test() {
	pushd test || die
	${RUBY} -Ilib:. -e "Dir['test_*'].each{|f| require f}" || die
	popd || die
}

each_ruby_install() {
	${RUBY} setup.rb install --prefix="${D}" \
		|| die "setup.rb install failed"
}

all_ruby_install() {
	diropts -o rbot -g nobody -m 0700
	keepdir /var/lib/rbot

	insinto /etc
	doins "${T}"/rbot.conf

	newinitd "${FILESDIR}/rbot.init2" rbot
	newconfd "${FILESDIR}/rbot.conf2" rbot
}

pkg_postinst() {
	elog "rbot can be started as a normal service."
	elog "Check /etc/conf.d/rbot file for more information about this feature."
	ewarn "DEPRECATION NOTICE:"
	ewarn "The bdb database backend is deprecated and only available on Ruby 1.8."
	ewarn "To migrate to the new tokyocabinet-based backend, change the core.db"
	ewarn "parameter in your bot's conf.yaml to 'tc' and restart rbot."
	ewarn "This procedure requires a Ruby version supporting both BDB and TC."
}
