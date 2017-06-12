using Base.Test
include("eegutilities.jl")




@testset "Normalize Tests" begin
@test normalize([2 4 8]) == [.25 .5 1]
@test normalize([1, 2, 4]) == [0.25, 0.5, 1]
end

@testset "Threshold_01 Tests" begin
@test threshold_01([1 2 3 4 5 6 7 8 9 10.5], 4) == [0 0 0 1 1 1 1 1 1 1]
@test threshold_01([1 2 3; 4 5 6], 3) == [0 0 1; 1 1 1]
end

#TODO highpass and lowpass tests aren't working yet
@testset "Lowpass Tests" begin
    q = linspace(0,1,150)
    sindata = sin(60*2*pi*q) + sin(200*2*pi*q)

    @test begin
        actual = lowpass(sindata, 65, 150)
        # print(format_full_array(actual))
        expected = [0.0, 0.711807070637017647030120315321, 0.025983875960371365793077913509, -0.975665099512987521457318962348, 1.104035186642847277127543748065, -0.266893794419766960945850087228, -0.817462414627789457632900393946, 1.273099211593460511338093965605, -0.830233202467945186064923746017, -0.003888329466166770814056219407, 0.474927770974582774687888786502, -0.294331015444627863697490965933, -0.127566301914583707377559562701, 0.131323544000171404944055097985, 0.494892464367036377659303525434, -1.240626088402048798897681081144, 1.302335434888988840995693863078, -0.343400446981696749748635966171, -1.111721553004237250661390135065, 2.036359240742044107719266321510, -1.730011944588890848706341785146, 0.403478608388685155983210961494, 0.990167872702820028862902290712, -1.532666760858142573908935446525, 1.052551444354962173477474607353, -0.170022062775824905900279304660, -0.326773876817456787602367285217, 0.187763674268896757491020821362, 0.146564169498526603030441606279, -0.057529027763216084023767393774, -0.578832637767136670703393974691, 1.207478853436902754836523854465, -1.091047778282459912446711314260, 0.039884927127425487403122872365, 1.307929057707019282474902865943, -1.949256586807033730934790582978, 1.344372405710752671481600373227, 0.109491053130903903678472488536, -1.382601769568396754550576588372, 1.639885896977429702303652447881, -0.880674677200861344417148757202, -0.145501185912555924817368691038, 0.640093315106287308324795048975, -0.431111679512735268549050715592, 0.029052304813484038092941119658, -0.048721610875113723071461180325, 0.562060561731893004733251473226, -1.000299739101531137919209868414, 0.705865418684831547047053845745, 0.378596080009681534850329853725, -1.541301848634604398924352608446, 1.847665483545442688395610275620, -0.943115527150253929455914203572, -0.598214195547864813207183942723, 1.704375960385665855767456378089, -1.658411064108016530482814232528, 0.644114636764766990140174129920, 0.471603391112516701078050118667, -0.904332521595982985473938242649, 0.580078862819176310772206761612, -0.087183551539338557945235663738, 0.037383763441795718474036647194, -0.452516109982090131147458578198, 0.753216100712028491237504113087, -0.356763801522777979080558452551, -0.683330236014582315107190879644, 1.615171731525234299908788671019, -1.600021740136899017770133468730, 0.469316531188096186522074049208, 1.056856492254182766643566537823, -1.911321288083325464768336132693, 1.531417497223027668340478157916, -0.291676789834516836386058002972, -0.846093699843214364086918521934, 1.144832920580176605085398477968, -0.652989118473732865766123723006, 0.045267041318355134837947417736, 0.070803178475895220400637697367, 0.274755011126033232837784225921, -0.490419776591868861181922056858, 0.059166485507823399214721860062, 0.877332742508083796018070188438, -1.556847171599081036674760980532, 1.255178536416747592241449638095, 0.019215585174998460471496031232, -1.437087700222884345535590000509, 1.981158376271750176655928044056, -1.270024983572049848135065985844, -0.137021903884364582015820133165, 1.215385365485875501789791996998, -1.311883298766742145247121698048, 0.618730513420476802011194195074, 0.101542682757880475818978993630, -0.254796485497854274804296892398, -0.068185009291064233027945817867, 0.256899703760972208943513805934, 0.151432388052147398616043005859, -0.947540942571093447455155001080, 1.381371620873549366237398317026, -0.851254686391156645264288727049, -0.476164676066124337161511448357, 1.703297939518428893990176220541, -1.903556018810384387052181409672, 0.892885308365814811537575224065, 0.602726192189906195828541513038, -1.535629458780413347795956724440, 1.373414883322082502559169370215, -0.467585576199317620726958466548, -0.338508717113542023646743928111, 0.481057542010681016275697174933, -0.125787367073894290614433089104, -0.088658810550375596881700346330, -0.256775590947932674801279517851, 0.901045284768547505294122856867, -1.120458383179613548463748884387, 0.434207121811082952245186561413, 0.858529210296675837632562888757, -1.832665153056348472659919934813, 1.685344772680893221661335701356, -0.433655467489965196214996012714, -1.058742676522795855831304834282, 1.765400136594332813899654865963, -1.308179596265904853780170924438, 0.204659669373982167073222626641, 0.637620164395538036039567941771, -0.709071750872043993219051571941, 0.267520113166991035935637910370, 0.011773987288183997146351345009, 0.253274159850861324549953224050, -0.759135508045440277058446554292, 0.814273185097985630065409168310, -0.049297464924984539524910331920, -1.133226849006411018905282617197, 1.818015207277915434858073240321, -1.348898163097543623223373288056, -0.064449562171188731762860868457, 1.458370526560116120506904735521, -1.872695321863464990030934131937, 1.110160899194369221731903962791, 0.149495015309392659252907265000, -0.960639862303336644622220319434, 0.896746620694372720272724563984, -0.324851250581566441955061463887, -0.038404435717768810321093297944, -0.152911344755877365297891401497, 0.554886158483838820565381411143, -0.506679353515239183636253983423, -0.264162743790698040236009092041, 1.280817162616812998621185215598, -1.668553304409151172293945819547, ]
        actual ≈ expected
    end

end

@testset "Highpass Tests" begin
  q = linspace(0,1,410)
  sindata = sin(60*2*pi*q) + sin(200*2*pi*q)

  @test begin
    actual = highpass(sindata, 200, 410)
    # print(format_full_array(actual))
    expected = [0.000000000000000000000000000000, 0.000000063279720057517188228247, -0.000000556787815483628244424849, 0.000002447037502237382589580358, -0.000007437182243313686567606248, 0.000018127729527215758088950701, -0.000038338230326758409661006000, 0.000073410573006519989642387758, -0.000130552862798369567060019492, 0.000219243035414957141739089597, -0.000351533135797742906942381369, 0.000542361744551471576525347729, -0.000809848600130297401403223212, 0.001175450096092083267923511514, -0.001664112243309027799539889791, 0.002304349780909928108868500729, -0.003128181375785384858018156606, 0.004171064413675893388366855419, -0.005471719987973687124305222085, 0.007071836748058528063221039872, -0.009015781913737733535563201315, 0.011350185582207811957333731812, -0.014123445862215616708468246543, 0.017385248804658328530825528446, -0.021185962575321522216587055709, 0.025576004894820616314410344216, -0.030605229688826042500071622499, 0.036322205031261184382529449977, -0.042773518829063675306123570863, 0.050003103666789755488153446095, -0.058051483491153868521372771738, 0.066955097060894419591647874768, -0.076745636499099254002054237844, 0.087449348163865930905203072143, -0.099086447922444170766098636705, 0.111670545133408016802434303827, -0.125208074926004442328775212445, 0.139697867198766340068871727453, -0.155130717884209623491642560111, 0.171489014977482590040835930267, -0.188746506578465006453981800405, 0.206868067011024947543518237580, -0.225809559504158957610187030696, 0.245517829694371858550994147663, -0.265930697040999308722319938170, 0.286977075158511896191271262069, -0.308577197813793058234210775481, 0.330642847541369744313044520823, -0.353077732236209362870482664221, 0.375777932339616815848870601258, -0.398632359928728474685044602666, 0.421523369091286792542661032712, -0.444327396864331758408184214204, 0.466915628529857407169600946872, -0.489154801015090345828184581478, 0.510907997045660255963639428956, -0.532035476953957142676188141195, 0.552395620044101476331377398310, -0.571845821828830924715703076799, 0.590243440212907644060180700762, -0.607446810205277687444436196529, 0.623316188217785671632498178951, -0.637714751699211768176667192165, 0.650509618133695455277631936042, -0.661572778142356598962692260102, 0.670782082978395033379115375283, -0.678022199387516621982285869308, 0.683185474442860485311257434660, -0.686172844997156916591052322474, 0.686894665303077411877552549413, -0.685271450774829204988236597273, 0.681234647506466672872704748443, -0.674727278863383794771380053135, 0.665704522270370802061734138988, -0.654134284963767242970789084211, 0.639997628155373088354451738269, -0.623289140024677057461133244942, 0.604017275443944678947616466758, -0.582204530738642200837773543753, 0.557887586819726277731490426959, -0.531117384947200066314110245003, 0.501959040485371210671416974947, -0.470491742049426231453423952189, 0.436808551515388443498011383781, -0.401016060460994139269530478487, 0.363234043811548890090534769115, -0.323594989202423688468002183072, 0.282243514093557745781026824261, -0.239335785163953151943871944241, 0.195038798678518809914805842709, -0.149529588824283243830848277867, 0.102994436487523779999442297139, -0.055627937393061217818956976089, 0.007632042492195871205562518469, 0.040784908784910721413208278818, -0.089409283128454086764236308227, 0.138023232409120039099192922549, -0.186405790874674265333865719185, 0.234334073456736818874546202096, -0.281584420860306827716357247482, 0.327933574158531915276881818500, -0.373159911957970547025098539962, 0.417044605908000243221778191582, -0.459372814162286202677165647401, 0.499934890729196945713397326472, -0.538527496179347475724341620662, 0.574954748858498843055997440388, -0.609029341902918242013242888788, 0.640573556657611731246504405135, -0.669420311117200239614533074928, 0.695414125926943516020628521801, -0.718411992828523082721403625328, 0.738284263689681252706975556066, -0.754915415814247148240667684149, 0.768204734315536819089231812541, -0.778066992197266049657855546684, 0.784432976753091870669720719889, -0.787249952842263400754063695786, 0.786482094520409846793995711778, -0.782110747400680872409850508120, 0.774134649093641158401624124963, -0.762570085366807370874653315695, 0.747450877205193986441145170829, -0.728828344901939151334602229326, 0.706771175973472054465673863888, -0.681365139466780012078572781320, 0.652712791062097119620943885820, -0.620933055163606972826073615579, 0.586160682013565192960413696710, -0.548545702378145150213128999894, 0.508252741459239154586668973934, -0.465460245985454212913623450731, 0.420359708237342921677281992743, -0.373154743750154394010820624317, 0.324060125312110147710598084814, -0.273300806833622123015459237649, 0.221110809350950510143718474865, -0.167732106492012061904617326036, 0.113413488543542606556968621589, -0.058409311260060138570882060094, 0.002978282729134967745515671922, 0.052617783556039417203198382822, -0.108115295709332995266471755258, 0.163250142141734250200713063350, -0.217758994120941073990849190523, 0.271380643845157698557102321502, -0.323857254695513518960581222927, 0.374935659878117888421655834463, -0.424368647000155752024852517934, 0.471916146960157378842382058792, -0.517346467692851308406432053744, 0.560437464341183022575876293558, -0.600977616771430356301664232888, 0.638767139031852115849119400082, -0.673618980955421164935614797287, 0.705359748868403357846545986831, -0.733830636080987197544800437754, 0.758888211042445193221794852434, -0.780405141902821064547879359452, 0.798270901076540306817719283572, -0.812392306236706773781008905644, 0.822694016840758601816219197644, -0.829118976236130400536694651237, 0.831628684094513626057221244992, -0.830203441673637243525263329502, 0.824842507554858439533518321696, -0.815564092854320299430526119977, 0.802405341692908891104707436170, -0.785422190782360751803992116038, 0.764689091238798912542051766650, -0.740298721254698310900721480721, 0.712361554568237242968109512731, -0.681005324376602771963007398881, 0.646374476263856134750085402629, -0.608629465216835474627998792130, 0.567945987548525432764279230469, -0.524514193369441161785005078855, 0.478537745374489675853624248703, -0.430232853533185077843370436312, 0.379827277351925729487192029410, -0.327559191345412836771089359900, 0.273676064349806402731246635085, -0.218433491990839473428920314291, 0.162093922903732368112628137169, -0.104925429801749334202121133330, 0.047200421379256021769954543288, 0.010805710523381976267964788008, -0.068815877510611384026972814354, 0.126552647167383514048566439669, -0.183739611897060256540115119606, 0.240102680914864918815254668516, -0.295371436631977346554123187161, 0.349280456894021318348109161889, -0.401570560173516666324644575070, 0.451990103597011860792065363057, -0.500296199548091458098042494385, 0.546255863582012057833026119624, -0.589647193390401391788202545285, 0.630260427038599302385080136446, -0.667898946489535516590763108979, 0.702380281491668645443837704079, -0.733536965249329098170960605785, 0.761217351416869303371015575976, -0.785286394640790197385626925097, 0.805626269612277567944147449452, -0.822136965943165431980332868989, 0.834736807537890257435719831847, -0.843362812121341898219384347613, 0.847971036470235306481413317670, -0.848536809379524692431573384965, 0.845054820293637543038300918852, -0.837539196815366371318134497415, 0.826023440046827595040213054745, -0.810560242343645764862003488815, 0.791221289646661163352803214366, -0.768096902593389807556434334401, 0.741295594223672082989651244134, -0.710943601159731985994483238755, 0.677184248232069685435874362156, -0.640177266858633409185586060630, 0.600098071006008537686682302592, -0.557136876313301998564497807820, 0.511497808613573301528276715544, -0.463397952409618063551732802807, 0.413066266864906439515436886722, -0.360742521388000225712744395423, 0.306676155438914133100070102955, -0.251125042692798783328100853396, 0.194354296675207566247323143216, -0.136634990430269609440472322603, 0.078242826246853747207410378905, -0.019456858953747373230935835409, -0.039441868305826965901417224813, 0.098171688357057196316901581667, -0.156451618311548440454217256956, 0.214002746293211254524635478447, -0.270549569291126501546784766106, 0.325821280820340619666097836671, -0.379553116604704088299371278481, 0.431487608373174680309602990746, -0.481375798714018920954060831718, 0.528978483276089872511249723175, -0.574067328160880463450155275495, 0.616425961708150671469752523990, -0.655851055182241404750698166026, 0.692153258698156581552041188843, -0.725158123424319067673593508516, 0.754706970243995245439805330534, -0.780657607936260600212108329288, 0.802885044946603065874057847395, -0.821282105753160296401915729803, 0.835759904790316476841383064311, -0.846248314507059506972552753723, 0.852696301528879097020308108767, -0.855072140089349175262611879589, 0.853363612454153597219885796221, -0.847578050711928487892521388858, 0.837742283860222314295640444470, -0.823902557577602889793411122810, 0.806124281775468909394533056911, -0.784491715640620590477283258224, 0.759107605807385454887992182194, -0.730092653815690550977990369574, 0.697584953090675585762880928087, -0.661739357284647389256804217439, 0.622726694723792939534234847088, -0.580732980314433100410553834081, 0.535958538560775132886249139119, -0.488617003264130322914837734061, 0.438934335531920960526974795357, -0.387147738026861809590428720185, 0.333504487086723477862193476540, -0.278260795234076374615739268847, 0.221680563848496381407215949366, -0.164034101165977025393871713277, 0.105596873790983883378835628264, -0.046648153516543305885377890263, -0.012530321801662962222234654064, 0.071655658424588541954847187299, -0.130445204195131253532835557962, 0.188617886973504400582868356651, -0.245895533906643815047488033088, 0.302004248893628313155090836517, -0.356675694215414673671205036953, 0.409648364739888748431440035347, -0.460668881737944069243440026185, 0.509493165507946987879961397994, -0.555887610780100627216882003268, 0.599630237228212736866339582775, -0.640511706645085165945374683361, 0.678336348394293020547252126562, -0.712923114088497733575877646217, 0.744106400071078866176321753301, -0.771736876635954027747743566579, 0.795682204159009365262988922041, -0.815827629901883732976841656637, 0.832076581891793676248880728963, -0.844351115680519348494215137180, 0.852592263468159750061658996856, -0.856760362873424718976878011745, 0.856835216714461278542103173095, -0.852816181867662503890414882335, 0.844722214371368518293081706361, -0.832591738375963119622724661895, 0.816482471771911799685028654494, -0.796471181699038632828546724340, 0.772653272309149818930507080950, -0.745142353823373571053423347621, 0.714069715960081397021497195965, -0.679583656671182478881121369341, 0.641848810742888464808686421748, -0.601045362189779330819305869227, 0.557368147065961272446088514698, -0.511025766818115290135438044672, 0.462239573540551285102395695503, -0.411242588879973447468785252568, 0.358278435866323907710295770812, -0.303600142302325570753396277723, 0.247468924401858331174608451875, -0.190152978498003694118878570407, 0.131926157033778135296842037860, -0.073066669792704305730346447945, 0.013855783401319919992400464537, 0.045423569193614066197284273585, -0.104488115187094138258672160191, 0.163055581690472378708633982569, -0.220846088647472404975502513480, 0.277583448623560380408292758148, -0.332996489787719063269122443671, 0.386820387242387597748205507742, -0.438797884101834290149213302357, 0.488680540678292474332522488112, -0.536229943723668944777216438524, 0.581218800796911017059187543055, -0.623432060199185511528696679306, 0.662667944172690814852444418648, -0.698738874041378910106914190692, 0.731472409628154185412540755351, -0.760712061609905454417912551435, 0.786318011604439925932297228428, -0.808167826642161135630715307343, 0.826157017019741979346747484669, -0.840199523191877517547254683450, 0.850228170193875087967683157331, -0.856194949757509204957273141190, 0.858071254374994762947892468219, -0.855848048022976315429843907623, 0.849535864259627349071024582372, -0.839164777004228312762279529124, 0.824784276963858919984318163188, -0.806462990207007179854770129168, 0.784288384885176048655353042705, -0.758366356727737667142719146796, 0.728820684552848430115545852459, -0.695792482157451375179846309038, 0.659439510336282785907258130464, -0.619935396435600249986919152434, 0.577468850711195358371696784161, -0.532242735714104853173012088519, 0.484473085949010007222881313282, -0.434388117833969022996143394266, 0.382227099171487949558212449119, -0.328239212019868942249445353809, 0.272682394598660282625246509269, -0.215822063213891329747085023882, 0.157929866498321774814783680085, -0.099282405747556728980995899292, 0.040159868527559747231059361638, 0.019155274493449506861830755611, -0.078379617701826900799666475450, 0.137230212321042793766068257355, -0.195425874588430442679864995625, 0.252688544762505185037326782549, -0.308744640974697726054642998861, 0.363326320598753027546479188459, -0.416172790349445043123211007696, 0.467031561715507637089217496396, -0.515659615913436675249670315679, 0.561824605973420099225279500388, -0.605305959034162510690180170059, 0.645895898981995064680461382522, -0.683400485020224768284435867827, 0.717640514347008151574414114293, -0.748452361691744338934029201482, 0.775688805399907366222578275483, -0.799219694139652325759470841149, 0.818932568980049846452118345042, -0.834733237281077067315493422939, 0.846546178429915086027790493972, -0.854314921782356462287566500891, 0.858002340209396252568296858954, -0.857590781789958289671460534009, 0.853082185759069355768247078231, -0.844498080827732255926321158768, 0.831879441640509975641748496855, -0.815286534693696607334345571871, 0.794798620770578279071116867271, -0.770513546281784034164274999057, 0.742547321710313457110430590546, -0.711033541860292661596076868591, 0.676122732518888880370866445446, -0.637981675035957707109446346294, 0.596792571721388442895772641350, -0.552752177303325376023224180244, 0.506070894342633081919302640017, -0.456971723231581195001638207032, 0.405689215490019017273937151913, -0.352468375343825024437194315396, 0.297563443689414952597616093044, -0.241236716275035983914065695899]
    actual ≈ expected
  end
end

@testset "Downsample Tests" begin
  @test downsample([1,2,3,4,5,6,7,8], 1/2) == [1,3,5,7]
end
