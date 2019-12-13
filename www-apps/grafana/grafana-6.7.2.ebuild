# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{4,5,6,7,8}} pypy{,3} )

inherit user systemd go-module python-any-r1

DESCRIPTION="Gorgeous metric viz, dashboards & editors for Graphite, InfluxDB & OpenTSDB"
HOMEPAGE="https://grafana.org"
EGIT_COMMIT="423a25fc3280922ae9d9834ad3079e5672e5c1fa"

# Dependencies:
# - js: MIT ISC BSD{,-2} Apache-2.0 CC0-1.0 Unlicense PublicDomain Artistic-2 CC-BY-3.0 CC-BY-4.0 MPL-2.0 WTFPL-2 Apache-2.0-with-LLVM-exceptions
#	(BSD || AFL-2.1) - json-schema
#	(MIT || GPL-3) - store2
#	(MIT && ZLIB) - pako
#	(BSD || GPL-2) - node-forge
#
#       can't work out automatically:
#
#       "torkelo/drop" MIT
#       "get-document" - MIT (no license in archive!)
#       async-foreach MIT
#       baron MIT
#       css-select BSD-2
#       component-indexof MIT
#       create-react-context MIT
#       expect.js MIT
#       flatbuffers Apache-2.0
#       indexof MIT
#       jscodeshift MIT
#       mousetrap Apache-2.0-with-LLVM-exceptions
#       nano-csv PublicDomain
#       optimist MIT
#       object.entries-ponyfill CC0-1.0
#       rst2html MIT
#       source-map BSD
#       systemjs-plugin-css MIT
#       trim MIT
#       text-encoding-utf PublicDomain
#       wordwrap MIT
# - go: Apache-2.0 MIT BSD{,-2} ISC MPL-2.0

LICENSE="Apache-2.0 MIT ISC BSD BSD-2 CC0-1.0 Unlicense MPL-2.0 Artistic-2 CC-BY-3.0 CC-BY-4.0 WTFPL-2 Apache-2.0-with-LLVM-exceptions ZLIB"
SLOT="0"
KEYWORDS=""
PROPERTIES="live"  # see notice in src_unpack
IUSE="+server +client cgo test"

BDEPEND="
	sys-apps/yarn
	>=net-libs/nodejs-12.16.2
	test? ( net-libs/nodejs[icu] )
	dev-libs/libsass
	>=dev-lang/go-1.13.0
	${PYTHON_DEPS}
"

RDEPEND="
	!www-apps/grafana-bin
	media-libs/fontconfig
"

EGO_PN="github.com/${PN}/${PN}"

SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

# Frontend source files are fetched during src_unpack. See a note there
RESTRICT="!test? ( test )"

pkg_setup() {
	# Please note, that new GLEP-81 bug is not introduced here as www-apps/grafana-bin is using the same user,
	enewgroup grafana
	enewuser grafana -1 -1 /usr/share/grafana grafana
}

src_unpack() {
	default

	pushd "${S}"

	echo "yarn-offline-mirror \"${T}/npm-dist/\"" > "${T}/yarnrc"

	yarn --use-yarnrc="${T}/yarnrc" --no-default-rc --ignore-scripts \
		--verbose --ignore-optional \
		--pure-lockfile --frozen-lockfile \
		--prefer-offline --check-files \
		--no-node-version-check --ignore-engines \
		--cache-folder="${T}/cache/" \
		install || die "Creating nodejs environment failed"
	rm -rfv node_modules/phantomjs-prebuilt/

	# At that point we can actually re-pack files in $T/cache and distribute them
	# separately. In this case we could drop PROPERTIES=live or RESTRICT=network-sandbox
	# placing our mega-package into SRC_URI.
	# Downside is that some of the packages contain precompiled binaries
}

src_prepare() {
	eapply_user

	{
		sed -i -z -E 's/\nphantomjs-.+79ISpKOWbTZHaE6ouniFSb4q7\+8=\n//' yarn.lock &&
		sed -i -z -E 's/\nnode-gyp@\^3.+\nnode-gyp@\^5/\nnode-gyp@\^5/' yarn.lock &&
		sed -i -E 's/    node-gyp .+/    node-gyp "^5.0.2"/' yarn.lock &&
		sed -i -E 's/.+phantomjs.+//' package.json
	} || \
		die "cannot fix file name in package.json and yarn.lock"

	local YARN_OPTIONS="--use-yarnrc=\"${T}/yarnrc\" --no-default-rc --verbose --ignore-optional--offline "
	YARN_OPTIONS="${YARN_OPTIONS} --ignore-engines --cache-folder=\"${T}/cache/\" --non-interactive --no-node-version-check"

	sed -i 's/"unknown-dev"/"'"${EGIT_COMMIT}"'"/' build.go || die

	sed -i -E "s/('node .+webpack\.js)(.+js')/{command: \1 --progress \2, options: {maxBuffer: Infinity}}/" \
		scripts/grunt/options/exec.js || die

	sed -i "s@'yarn @'yarn ${YARN_OPTIONS} @" scripts/grunt/options/exec.js || die
	sed -i "s@\tyarn @\tyarn ${YARN_OPTIONS} @" Makefile || die
	sed -i 's/$(GO) test -v /$(GO) test /' Makefile || die
	sed -i 's/--no-progress/--ignore-scripts --frozen-lockfile/' Makefile || die

	use test && { sed -i 's/verbose: false/verbose: true/' jest.config.js || die; }
}

src_compile() {
	# -mod=readonly forces online activity for some reason
	export GOFLAGS="-mod=vendor -x -v"

	if use client; then
		go run ./build.go  \
			-skipRpm=true -skipDeb=true \
			-cgo-enabled="$(usex cgo true false)" \
			build-cli || die "Building client: failed"
	fi

	if use server; then
		go run build.go \
			-skipRpm=true -skipDeb=true \
			-cgo-enabled="$(usex cgo true false)" \
			build-server || die "Building server (go): failed";

		emake node_modules

		pushd node_modules/node-sass/
		rm -vrf ./src/libsass
		SKIP_SASS_BINARY_DOWNLOAD_FOR_CI=1 \
		GYP_GENERATOR_FLAGS="--verbose" \
		../node-gyp/bin/node-gyp.js rebuild --libsass_ext=auto \
			--verbose --devdir=. --nodedir=/usr/include/node/ || \
		die "Error building node-sass"

		local NODE_SASS_PATH="$(
			echo "console.log(require('./lib/extensions.js').getBinaryPath())" |
			node || die "Cannot determine arch type for node-sass"
		)"

		mkdir -p "$(dirname "${NODE_SASS_PATH}")"
		ln -rsf ./build/Release/binding.node "${NODE_SASS_PATH}"
		popd

		mkdir -p ./node_modules/phantomjs-prebuilt/lib/

		# just a trick to get going
		echo '
module.exports.location = "/usr/local/bin/phantomjs"
module.exports.platform = "linux"
module.exports.arch = "x64"
' > ./node_modules/phantomjs-prebuilt/lib/location.js

		NODE_ENV=production \
			node_modules/grunt-cli/bin/grunt release --verbose || die "Failed building frontend"
	fi
}

src_install() {
	keepdir /etc/grafana
	insinto /etc/grafana
	newins "${S}/conf/sample.ini" grafana.ini
	rm "${S}/conf/sample.ini" || die

	use client && dobin bin/*/grafana-cli

	if use server; then
		# Frontend assets
		insinto "/usr/share/${PN}" && doins -r public conf
		dobin bin/*/grafana-server
		insinto /usr/share/grafana/tools/phantomjs
		doins tools/phantomjs/render.js
		newconfd "${FILESDIR}/grafana.confd" grafana
		newinitd "${FILESDIR}/grafana.initd.3" grafana
		systemd_newunit "${FILESDIR}/grafana.service" grafana.service
	fi

	keepdir /var/{lib,log}/grafana
	keepdir /var/lib/grafana/{dashboards,plugins}
	fowners grafana:grafana /var/{lib,log}/grafana
	fowners grafana:grafana /var/lib/grafana/{dashboards,plugins}
	fperms 0750 /var/{lib,log}/grafana
	fperms 0750 /var/lib/grafana/{dashboards,plugins}
}

postinst() {
	elog "${PN} has built-in log rotation. Please see [log.file] section of"
	elog "/etc/grafana/grafana.ini for related settings."
	elog
	elog "You may add your own custom configuration for app-admin/logrotate if you"
	elog "wish to use external rotation of logs. In this case, you also need to make"
	elog "sure the built-in rotation is turned off."
	elog
	elog "Current ${PN} version relies on external services for screenshoting."
	elog "Upstream is transitioning away from PhantomJS but still provides PhJS binary"
	elog "for this purpose. Gentoo package ${PN} doesn't contain this binary neither"
	elog "downloaded nor built from sources."
}
