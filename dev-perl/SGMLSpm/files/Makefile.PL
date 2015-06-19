use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
      'NAME'   => 'SGMLS',
      'VERSION'        => '1.03ii',
      'PM'     => { 'SGMLS.pm' => '$(INST_LIBDIR)/SGMLS.pm',
                    'Output.pm' => '$(INST_LIBDIR)/SGMLS/Output.pm',
                    'Refs.pm' => '$(INST_LIBDIR)/SGMLS/Refs.pm',
                    'skel.pl' => '$(INST_LIBDIR)/sgmlspl-specs/skel.pl',
                },
      'MAN3PODS'=> { 'SGMLS.pm' => '$(INST_MAN3DIR)/SGMLS.3pm',
                    'Output.pm' => '$(INST_MAN3DIR)/SGMLS::Output.3pm',
                    'Refs.pm' => '$(INST_MAN3DIR)/SGMLS::Refs.3pm',
                },
      'EXE_FILES' => [ 'sgmlspl', ],
);
