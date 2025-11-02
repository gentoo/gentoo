# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.adoc LICENSE.txt README.adoc"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A set of Asciidoctor extensions that enable you to add diagrams"
HOMEPAGE="https://github.com/asciidoctor/asciidoctor-diagram"
SRC_URI="https://github.com/asciidoctor/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# Supported backends dictionary: <backend-name> <dependencies> <removal-function>
# backend-name: The name of the USE flag, a gem spec file in ./spec, a
#   directory in ./lib/asciidoctor-diagram/, and a require directive in
#   ./lib/asciidoctor.rb which will be removed if the former is unset.
# dependencies: Dependencies for RDEPEND if the USE flag is set, and for
#   DEPEND if the "test" USE flag is set.
# removal-function: Additional commands to evaluate, if the USE flag is unset.
#
# NB: Do not implicitly use functions following a naming scheme instead
# of an explicit <removal-function> to prevent accidental or malicious
# injection from functions exported in the parent environment.
backend_dict_stride=3
backends=(
	"barcode" "dev-ruby/rqrcode dev-ruby/barby[qrcode]" ""
	"ditaa" "media-gfx/ditaa" "remove_ditaa"
	"gnuplot" "sci-visualization/gnuplot" ""
	"graphviz" "media-gfx/graphviz" ""
	"lilypond" "media-sound/lilypond" ""
	"meme" "media-gfx/imagemagick[png]" ""
	"mscgen" "media-gfx/mscgen[png]" ""
	"plantuml" "media-gfx/plantuml" "remove_plantuml"
	"tikz" "dev-tex/pgf media-gfx/pdf2svg" ""
)

remove_plantuml() {
	rm -f "spec/salt.rb"
	sed -i "/\\/salt'/d" "lib/asciidoctor-diagram.rb"
	sed -i "/plantuml/d" "asciidoctor-diagram.gemspec"
}

remove_ditaa() {
	sed -i "/ditaa/d" "asciidoctor-diagram.gemspec"
}

IUSE=""
DEPEND+="test? ("

i=0
while (( i < ${#backends[@]} ))
do
	backend="${backends[i]}"
	deps="${backends[i+1]}"

	IUSE+=" $backend"
	RDEPEND+=" $backend? ( $deps )"
	DEPEND+=" $deps"

	((i+=backend_dict_stride))
done

DEPEND+=" )"

ruby_add_rdepend ">=dev-ruby/asciidoctor-1.5.7 <dev-ruby/asciidoctor-3 dev-ruby/rexml"

all_ruby_prepare() {
	rm Gemfile || die
	sed -e '/c.formatter/ s:^:#:' \
		-e '/logger.*DEBUG/ s:^:#:' \
		-i spec/test_helper_methods.rb || die

	# Delete everything related to unsupported backends. Obtain list of backends from spec/
	for spec in spec/*_spec.rb
	do
		backend="${spec##spec/}"
		backend="${backend%%_spec.rb}"

		backend_index=0

		get_backend_index() {
			local i=0
			while (( i < ${#backends[@]} ))
			do
				if [[ "${backends[i]}" == "$backend" ]]
				then
					echo "$i"
					return 1
				fi
				((i+=backend_dict_stride))
			done
		}

		if backend_index="$(get_backend_index)" || ! use "$backend"
		then
			rm -f "spec/${backend}_spec.rb"
			rm -Rf "lib/asciidoctor-diagram/"{"$backend.rb","$backend"}
			sed -i "/\\/$backend'/d" "lib/asciidoctor-diagram.rb"
			removal="${backends[backend_index+2]}"
			if [[ "$removal" ]]
			then
				"$removal"
			fi
		fi
	done
}

all_ruby_install() {
	all_fakegem_install
}
