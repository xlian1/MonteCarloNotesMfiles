%% Pricing American Options
% Pricing American options is more difficult because the excercise time
% must be computed simultaneously with the payoff of a particular path
% Longstaff and Schwartz proposed a method based on linear regression for
% pricing American options.  This has been implemented in GAIL. It is
% illustrated here.
%
% Since the price of an American call option is the same as a European
% call, we only deal with American put options.

%% Initialization
% First we set up the basic common praramters for our examples.

gail.InitializeWorkspaceDisplay %initialize the workspace and the display parameters
inp.timeDim.timeVector = 1/52:1/52:1/4; %weekly monitoring for three months
inp.assetParam.initPrice = 100; %initial stock price
inp.assetParam.interest = 0.05; %risk-free interest rate
inp.assetParam.volatility = 0.5; %volatility
inp.payoffParam.strike = 130; %strike price
inp.payoffParam.putCallType = {'put'}; %put option
inp.priceParam.absTol = 0.05; %absolute tolerance of a nickel
inp.priceParam.relTol = 0; %zero relative tolerance
EuroPut = optPrice(inp) %construct an optPrice object 

%%
% Note that the default is a European call option.  Its exact price is
% coded in

disp(['The price of the European option is $' num2str(EuroPut.exactPrice)])

%% American Put Options
% To construct an American put |optPrice| object, we copy the European put
% object and change the relevant property: 

AmericanPut = optPrice(EuroPut); %make a copy 
AmericanPut.payoffParam.optType = {'american'}; %change from European to American

%%
% Next we genrate the price using the |genOptPrice| method of the |optPrice|
% object. 

[AmericanPutPrice,out] = genOptPrice(AmericanPut); %uses meanMC_g to compute the price
disp(['The price of the American option is $' num2str(AmericanPutPrice) ...
   ' +/- $' num2str(max(AmericanPut.priceParam.absTol, ...
   AmericanPut.priceParam.relTol*AmericanPutPrice)) ])
disp(['   and it took ' num2str(out.time) ' seconds to compute']) %display results nicely

%%
% Notice that these two prices are similar.  If the interest rate is
% decreased, then the prices are even closer together.

%% Plotting the Paths
% We can plot the stock paths and the strike price.  Here the plotting
% function uses 1e5 paths to compute the exercise boundary.

figure
plot(AmericanPut,'paths',300)
xlabel('Time, \(t\)')
ylabel('Stock Price, \(S\)')
axis([0 AmericanPut.timeDim.timeVector(end) 0 2*AmericanPut.payoffParam.strike])
text(0.05,180,'\(P = 0 < H = V\)')
text(0.05,110,'\(0 < P < H = V\)')
text(0.05,30,'\(0 < H < P = V\)')
print -depsc AmerPutPathsExer.eps

%%
% _Author: Fred J. Hickernell_
